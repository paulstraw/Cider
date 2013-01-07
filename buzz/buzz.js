// Generated by CoffeeScript 1.4.0
(function() {
  var BuzzGame, Layer, LayerList, LayerOptions, Level, LevelOptions, Loader, Map, Renderer, TileCursor, TilePicker, ciderStuff, collMap, uniqueLayerId,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Map = (function() {

    function Map(data, options) {
      this.data = data;
      if (options == null) {
        options = {};
      }
      if (!this.data) {
        throw new Error('Cider Maps require an array containing map data');
      }
      this.type = c.mapType.regular;
      this.distance = 1;
      c.extend(this, options);
      if (this.type !== c.mapType.collision && !this.tileset) {
        throw new Error('Non-collision Cider Maps require a tileset.');
      }
    }

    return Map;

  })();

  /* --------------------------------------------
       Begin level.coffee
  --------------------------------------------
  */


  Level = (function() {

    function Level(game, options) {
      var map, _i, _len, _ref;
      this.game = game;
      if (options == null) {
        options = {};
      }
      this.addMap = __bind(this.addMap, this);

      this.setPxSize = __bind(this.setPxSize, this);

      this.size = {
        x: 50,
        y: 25
      };
      this.tileSize = 32;
      this.maps = [];
      c.extend(this, options);
      _ref = this.maps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        map = _ref[_i];
        this.addMap(map);
      }
      this.setPxSize();
    }

    Level.prototype.setPxSize = function() {
      return this.pxSize = {
        x: this.size.x * this.tileSize,
        y: this.size.y * this.tileSize
      };
    };

    Level.prototype.addMap = function(map) {
      var _ref;
      return (_ref = map.tileSize) != null ? _ref : map.tileSize = this.tileSize;
    };

    return Level;

  })();

  /* --------------------------------------------
       Begin loader.coffee
  --------------------------------------------
  */


  Loader = (function() {

    function Loader(parent, resources, resourcesPrefix) {
      var key, val, _ref;
      this.parent = parent;
      this.resources = resources != null ? resources : {};
      this.resourcesPrefix = resourcesPrefix != null ? resourcesPrefix : '';
      this._updateComplete = __bind(this._updateComplete, this);

      this._imageError = __bind(this._imageError, this);

      this._imageLoaded = __bind(this._imageLoaded, this);

      this._soundError = __bind(this._soundError, this);

      this._soundLoaded = __bind(this._soundLoaded, this);

      this._loadSound = __bind(this._loadSound, this);

      this._initializeResource = __bind(this._initializeResource, this);

      this.percentComplete = 0;
      this.completed = 0;
      this.resourceCount = Object.keys(this.resources).length;
      _ref = this.resources;
      for (key in _ref) {
        val = _ref[key];
        this._initializeResource(key, val);
      }
    }

    Loader.prototype._initializeResource = function(key, val) {
      var audioElement, imgElement, resourceUrl, sourceElement, _i, _len;
      if (Array.isArray(val)) {
        audioElement = new Audio();
        for (_i = 0, _len = val.length; _i < _len; _i++) {
          resourceUrl = val[_i];
          sourceElement = document.createElement('source');
          sourceElement.src = this.resourcesPrefix + resourceUrl;
          audioElement.appendChild(sourceElement);
        }
        audioElement.addEventListener('canplaythrough', this._soundLoaded);
        audioElement.addEventListener('error', this._soundError);
        this._loadSound(audioElement);
        return this.resources[key] = audioElement;
      } else {
        imgElement = new Image();
        imgElement.addEventListener('load', this._imageLoaded);
        imgElement.addEventListener('error', this._imageError);
        imgElement.src = this.resourcesPrefix + val;
        return this.resources[key] = imgElement;
      }
    };

    Loader.prototype._loadSound = function(el) {
      document.body.appendChild(el);
      el.volume = 0;
      return el.play();
    };

    Loader.prototype._soundLoaded = function(e) {
      var el;
      el = e.target;
      el.pause();
      el.currentTime = 0;
      el.removeEventListener('canplaythrough', this._soundLoad);
      el.removeEventListener('error', this._soundError);
      return this._updateComplete();
    };

    Loader.prototype._soundError = function(e) {
      var el, src;
      el = e.target;
      el.removeEventListener('canplaythrough', this._soundLoad);
      el.removeEventListener('error', this._soundError);
      src = el.firstChild.src;
      throw new Error("" + (src.substr(0, src.lastIndexOf('.'))) + " failed to load.");
      return this._updateComplete();
    };

    Loader.prototype._imageLoaded = function(e) {
      var el;
      el = e.target;
      el.removeEventListener('load', this._imageLoaded);
      el.removeEventListener('error', this._imageError);
      return this._updateComplete();
    };

    Loader.prototype._imageError = function(e) {
      var el;
      el = e.target;
      el.removeEventListener('load', this._imageLoaded);
      el.removeEventListener('error', this._imageError);
      throw new Error("" + el.src + " failed to load.");
    };

    Loader.prototype._updateComplete = function() {
      var el, name, _ref, _ref1;
      this.completed++;
      this.percentComplete = Math.round(this.completed / this.resourceCount * 100);
      if (this.percentComplete === 100) {
        _ref = this.resources;
        for (name in _ref) {
          el = _ref[name];
          if (el.tagName === 'AUDIO') {
            el.volume = 1;
          }
        }
        return (_ref1 = this.parent) != null ? typeof _ref1.ready === "function" ? _ref1.ready() : void 0 : void 0;
      }
    };

    return Loader;

  })();

  /* --------------------------------------------
       Begin init.coffee
  --------------------------------------------
  */


  ciderStuff = {
    mapType: Object.freeze({
      regular: 0,
      collision: 1
    }),
    extend: function(dest) {
      var key, source, val, _i, _len, _ref;
      _ref = Array.prototype.slice.call(arguments, 1);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        source = _ref[_i];
        for (key in source) {
          val = source[key];
          dest[key] = val;
        }
      }
      return dest;
    }
  };

  collMap = document.createElement('img');

  collMap.src = 'img/collision.png';

  window.c = window.Cider = ciderStuff;

  /* --------------------------------------------
       Begin tileCursor.coffee
  --------------------------------------------
  */


  TileCursor = (function() {

    function TileCursor(painter) {
      this.painter = painter != null ? painter : false;
      this.setTileset = __bind(this.setTileset, this);

      this.setTile = __bind(this.setTile, this);

      this.moveToClosest = __bind(this.moveToClosest, this);

      this.setSize = __bind(this.setSize, this);

      this.stopPainting = __bind(this.stopPainting, this);

      this.paint = __bind(this.paint, this);

      this.startPainting = __bind(this.startPainting, this);

      this.bindEvents = __bind(this.bindEvents, this);

      this.el = $('<div class="cursor">');
      this.bindEvents();
    }

    TileCursor.prototype.bindEvents = function() {
      if (this.painter) {
        this.el.on('mousedown', this.startPainting);
        return this.el.on('mouseup', this.stopPainting);
      }
    };

    TileCursor.prototype.startPainting = function(e) {
      if (e.which !== 1) {
        return;
      }
      this.painting = true;
      return this.paint();
    };

    TileCursor.prototype.paint = function(e) {
      var col, elPos, layer, row, tileSize, zoom;
      if (!(this.painting && (this.index != null) && (window.buzz.currentLayer != null))) {
        return;
      }
      layer = window.buzz.currentLayer;
      tileSize = layer.tileSize;
      elPos = this.el.position();
      zoom = window.buzz.zoom;
      row = elPos.top / zoom / tileSize;
      col = elPos.left / zoom / tileSize;
      if (layer.data[row]) {
        layer.data[row][col] = this.index;
      } else {
        layer.data[row] = [];
        layer.data[row][col] = this.index;
      }
      return window.buzz.renderer.renderLayers();
    };

    TileCursor.prototype.stopPainting = function(e) {
      return this.painting = 0;
    };

    TileCursor.prototype.setSize = function(size) {
      var es;
      this.size = size;
      es = this.el[0].style;
      es.width = "" + size + "px";
      return es.height = "" + size + "px";
    };

    TileCursor.prototype.moveToClosest = function(x, y) {
      var es;
      es = this.el[0].style;
      es.left = "" + (Math.floor(x / this.size) * this.size) + "px";
      es.top = "" + (Math.floor(y / this.size) * this.size) + "px";
      if (this.painting) {
        return this.paint();
      }
    };

    TileCursor.prototype.setTile = function(index, xPos, yPos) {
      var layer;
      this.index = index;
      if (this.index == null) {
        return;
      }
      layer = window.buzz.currentLayer;
      if (this.index === 0) {
        return this.el.css({
          backgroundPosition: '9999px 9999px'
        });
      } else {
        if (layer.type === c.mapType.collision) {
          return this.el.css({
            backgroundPosition: "" + (xPos * (layer.tileSize / 32) - 1) + "px " + (yPos * (layer.tileSize / 32) - 1) + "px"
          });
        } else {
          return this.el.css({
            backgroundPosition: "" + (xPos - 1) + "px " + (yPos - 1) + "px"
          });
        }
      }
    };

    TileCursor.prototype.setTileset = function(setName) {
      if (!setName || setName === 'Select…') {
        this.el.css({
          backgroundImage: ''
        });
        return;
      }
      this.index = 1;
      if (setName === 'cider collision') {
        this.tileset = {
          src: 'img/collision.png'
        };
        this.el.css('background-size', 256 * (window.buzz.currentLayer.tileSize / 32));
      } else {
        this.tileset = window.buzz.resources[setName];
        this.el.css('background-size', 'auto');
      }
      return this.el.css({
        backgroundImage: "url(" + this.tileset.src + ")",
        backgroundPosition: '0 0'
      });
    };

    return TileCursor;

  })();

  /* --------------------------------------------
       Begin tilePicker.coffee
  --------------------------------------------
  */


  TilePicker = (function() {

    function TilePicker() {
      this.handleDeleteClick = __bind(this.handleDeleteClick, this);

      this.handleCursorClick = __bind(this.handleCursorClick, this);

      this.handleImgMousemove = __bind(this.handleImgMousemove, this);

      this.hide = __bind(this.hide, this);

      this.show = __bind(this.show, this);

      this.maybeShowOrHide = __bind(this.maybeShowOrHide, this);

      this.bindEvents = __bind(this.bindEvents, this);
      this.el = $('#tile-picker');
      $('body').append(this.el);
      this.inner = this.el.find('.inner');
      this.img = this.el.find('.tiles');
      this.cursor = new TileCursor;
      this.inner.append(this.cursor.el);
      this.bindEvents();
    }

    TilePicker.prototype.bindEvents = function() {
      $(document).on('keypress', this.maybeShowOrHide);
      this.el.on('click', this.hide);
      this.img.on('mousemove', this.handleImgMousemove);
      this.el.on('click', '.delete', this.handleDeleteClick);
      return this.cursor.el.on('click', this.handleCursorClick);
    };

    TilePicker.prototype.maybeShowOrHide = function(e) {
      var _ref;
      if (((_ref = e.target.tagName) === 'INPUT' || _ref === 'SELECT' || _ref === 'TEXTAREA') || e.which !== 32) {
        return;
      }
      if (!(window.buzz.currentLayer && window.buzz.currentLayer.tileset)) {
        alert('Select a layer and choose its tileset before picking a tile.');
        return;
      }
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    };

    TilePicker.prototype.show = function() {
      var layer, setName;
      layer = window.buzz.currentLayer;
      this.visible = true;
      this.cursor.setSize(layer.type === c.mapType.collision ? 32 : layer.tileSize);
      setName = layer.tileset;
      if (setName === 'cider collision') {
        this.setImg = new Image;
        this.setImg.src = 'img/collision.png';
      } else {
        this.setImg = window.buzz.resources[setName];
      }
      this.img[0].src = this.setImg.src;
      this.el.find('.delete').css({
        left: -layer.tileSize,
        width: layer.tileSize,
        height: layer.tileSize
      });
      this.inner.css({
        marginTop: -(this.setImg.height / 2),
        marginLeft: -(this.setImg.width / 2)
      });
      return this.el.fadeIn(60);
    };

    TilePicker.prototype.hide = function() {
      this.visible = false;
      return this.el.fadeOut(60);
    };

    TilePicker.prototype.handleImgMousemove = function(e) {
      if (e.target === this.cursor.el[0]) {
        return;
      }
      return this.cursor.moveToClosest(e.offsetX, e.offsetY);
    };

    TilePicker.prototype.handleCursorClick = function(e) {
      var currentColumn, currentRow, cursorPos, index, layer, tilesPerRow;
      e.stopPropagation();
      layer = window.buzz.currentLayer;
      if (layer.type === c.mapType.collision) {
        tilesPerRow = this.setImg.width / 32;
        cursorPos = this.cursor.el.position();
        currentColumn = (cursorPos.left / 32) + 1;
        currentRow = cursorPos.top / 32;
      } else {
        tilesPerRow = this.setImg.width / layer.tileSize;
        cursorPos = this.cursor.el.position();
        currentColumn = (cursorPos.left / layer.tileSize) + 1;
        currentRow = cursorPos.top / layer.tileSize;
      }
      index = (tilesPerRow * currentRow) + currentColumn;
      window.buzz.renderer.cursor.setTile(index, -cursorPos.left, -cursorPos.top);
      return setTimeout(this.hide, 60);
    };

    TilePicker.prototype.handleDeleteClick = function(e) {
      e.stopPropagation();
      window.buzz.renderer.cursor.setTile(0);
      return setTimeout(this.hide, 60);
    };

    return TilePicker;

  })();

  /* --------------------------------------------
       Begin renderer.coffee
  --------------------------------------------
  */


  Renderer = (function() {

    function Renderer() {
      this.switchLayer = __bind(this.switchLayer, this);

      this.handleInnerMousemove = __bind(this.handleInnerMousemove, this);

      this.handleZoomChange = __bind(this.handleZoomChange, this);

      this.handleMouseup = __bind(this.handleMouseup, this);

      this.handleMousemove = __bind(this.handleMousemove, this);

      this.handleMousedown = __bind(this.handleMousedown, this);

      this.handleContext = __bind(this.handleContext, this);

      this.renderLayer = __bind(this.renderLayer, this);

      this.renderLayers = __bind(this.renderLayers, this);

      this.updateLevel = __bind(this.updateLevel, this);

      this.loadLevel = __bind(this.loadLevel, this);

      this.bindEvents = __bind(this.bindEvents, this);
      this.el = $('#rendering-container');
      this.inner = $('#inner');
      this.inner.css('transform-origin', 'left top');
      this.bindEvents();
    }

    Renderer.prototype.bindEvents = function() {
      this.el.on('mousedown', this.handleMousedown);
      this.el.on('mouseup', this.handleMouseup);
      this.el.on('mousemove', this.handleMousemove);
      this.el.on('contextmenu', this.handleContext);
      this.inner.on('mousemove', this.handleInnerMousemove);
      return $('#zoom-level').on('change', this.handleZoomChange);
    };

    Renderer.prototype.loadLevel = function(level) {
      this.level = level;
      if (!this.level) {
        throw 'Renderer.loadLevel requires a level';
      }
      this.levelEl = $('<div id="level-container">');
      this.levelEl.css({
        width: this.level.pxSize.x,
        height: this.level.pxSize.y
      });
      this.inner.html(this.levelEl);
      this.cursor = new TileCursor(true);
      this.inner.append(this.cursor.el);
      this.cursor.setSize(this.level.tileSize);
      return this.renderLayers();
    };

    Renderer.prototype.updateLevel = function() {
      var level;
      if (!window.buzz.level) {
        return;
      }
      level = window.buzz.level;
      this.levelEl.css({
        width: level.pxSize.x,
        height: level.pxSize.y
      });
      return this.cursor.setSize(window.buzz.currentLayer != null ? window.buzz.currentLayer.tileSize : level.tileSize);
    };

    Renderer.prototype.renderLayers = function() {
      var id, layer, _ref, _results;
      this.el.find('#level-container').html('');
      _ref = window.buzz.layers;
      _results = [];
      for (id in _ref) {
        layer = _ref[id];
        _results.push(this.renderLayer(layer));
      }
      return _results;
    };

    Renderer.prototype.renderLayer = function(layer) {
      if (layer.visible) {
        return $('#level-container').append(layer.render());
      }
    };

    Renderer.prototype.handleContext = function(e) {
      return e.preventDefault();
    };

    Renderer.prototype.handleMousedown = function(e) {
      if (e.which === 3) {
        return this.dragStart = {
          x: e.clientX,
          y: e.clientY,
          origX: this.inner.offset().left,
          origY: this.inner.offset().top
        };
      }
    };

    Renderer.prototype.handleMousemove = function(e) {
      var delta;
      if (!this.dragStart) {
        return;
      }
      delta = {
        x: e.clientX - this.dragStart.x,
        y: e.clientY - this.dragStart.y
      };
      this.inner[0].style.top = "" + (this.dragStart.origY + delta.y) + "px";
      return this.inner[0].style.left = "" + (this.dragStart.origX + delta.x) + "px";
    };

    Renderer.prototype.handleMouseup = function(e) {
      return this.dragStart = null;
    };

    Renderer.prototype.handleZoomChange = function(e) {
      var zoom;
      zoom = $(e.target).val();
      window.buzz.zoom = zoom;
      return this.inner.css('transform', "scale(" + zoom + ")");
    };

    Renderer.prototype.handleInnerMousemove = function(e) {
      if (this.dragStart) {
        return;
      }
      if (e.target === this.cursor.el[0]) {
        return;
      }
      return this.cursor.moveToClosest(e.offsetX, e.offsetY);
    };

    Renderer.prototype.switchLayer = function() {
      var layer;
      if (window.buzz.currentLayer) {
        layer = window.buzz.currentLayer;
        this.cursor.setSize(layer.tileSize);
        return this.cursor.setTileset(layer.tileset);
      } else {
        this.cursor.setSize(this.level.tileSize);
        return this.cursor.setTileset(null);
      }
    };

    return Renderer;

  })();

  /* --------------------------------------------
       Begin buzzGame.coffee
  --------------------------------------------
  */


  BuzzGame = (function() {

    function BuzzGame() {}

    return BuzzGame;

  })();

  /* --------------------------------------------
       Begin layerList.coffee
  --------------------------------------------
  */


  LayerList = (function() {

    LayerList.prototype._layerTemplate = function(layer) {
      return $("<li data-layer-id=\"" + layer.id + "\" class=\"layer group\">\n	<input type=\"checkbox\" class=\"toggle-visibility\" " + (layer.visible ? 'checked' : '') + ">\n	<span class=\"name\">" + layer.name + "</span>\n	<button class=\"delete\">&times;</button>\n</li>");
    };

    function LayerList() {
      this.addLayer = __bind(this.addLayer, this);

      this.toggleLayerVisibility = __bind(this.toggleLayerVisibility, this);

      this.deleteLayer = __bind(this.deleteLayer, this);

      this.toggleCurrentLayer = __bind(this.toggleCurrentLayer, this);

      this.bindEvents = __bind(this.bindEvents, this);
      this.el = $('#layer-list');
      this.bindEvents();
    }

    LayerList.prototype.bindEvents = function() {
      this.el.on('click', '.layer', this.toggleCurrentLayer);
      this.el.on('click', '.layer .delete', this.deleteLayer);
      this.el.on('click', '#add-layer', this.addLayer);
      this.el.on('change', '.layer .toggle-visibility', this.toggleLayerVisibility);
      return this.el.on('click', '.layer .toggle-visibility', this.stopPropagation);
    };

    LayerList.prototype.stopPropagation = function(e) {
      return e.stopPropagation();
    };

    LayerList.prototype.toggleCurrentLayer = function(e) {
      var layer, layerEl;
      layerEl = $(e.currentTarget);
      if (layerEl.hasClass('current')) {
        return;
      }
      layerEl.addClass('current').siblings().removeClass('current');
      layer = window.buzz.layers[parseInt(layerEl.data('layer-id'), 10)];
      window.buzz.currentLayer = layer;
      window.buzz.layerOptions.load(layer);
      return window.buzz.renderer.switchLayer();
    };

    LayerList.prototype.deleteLayer = function(e) {
      var layer, layerEl, layerId;
      e.stopPropagation();
      layerEl = $(e.currentTarget).parent();
      layerId = parseInt(layerEl.data('layer-id'), 10);
      layer = window.buzz.layers[layerId];
      window.buzz.layerOptions.unload(layer);
      window.buzz.currentLayer = null;
      delete window.buzz.layers[layerId];
      window.buzz.renderer.switchLayer();
      window.buzz.renderer.renderLayers();
      layerEl.off();
      return layerEl.slideUp(180, function() {
        return layerEl.remove();
      });
    };

    LayerList.prototype.toggleLayerVisibility = function(e) {
      var clicked, layer, layerEl;
      clicked = $(e.currentTarget);
      layerEl = clicked.parent();
      layer = window.buzz.layers[parseInt(layerEl.data('layer-id'), 10)];
      layer.visible = !!clicked.prop('checked');
      return window.buzz.renderer.renderLayers();
    };

    LayerList.prototype.addLayer = function() {
      var layer, listEl;
      layer = new window.buzz.Layer;
      listEl = this._layerTemplate(layer);
      listEl.on('updateName', function() {
        return listEl.find('.name').text(layer.name);
      });
      layer.listEl = listEl;
      window.buzz.layers[layer.id] = layer;
      return this.el.find('ul').append(listEl);
    };

    return LayerList;

  })();

  /* --------------------------------------------
       Begin layer.coffee
  --------------------------------------------
  */


  uniqueLayerId = 1;

  Layer = (function() {

    function Layer(options) {
      this.renderTile = __bind(this.renderTile, this);

      this.render = __bind(this.render, this);
      this.name = 'New Layer';
      this.type = c.mapType.regular;
      this.distance = 1;
      this.zIndex = 1;
      this.tileSize = 32;
      this.visible = true;
      this.id = uniqueLayerId++;
      this.el = $('<div class="layer">');
      this.data = [];
      c.extend(this, options);
    }

    Layer.prototype.render = function() {
      var col, i, img, j, mapContainer, mcs, row, tilesPerRow, _i, _j, _len, _len1, _ref;
      if (!this.tileset) {
        return;
      }
      if (this.tileset === 'cider collision') {
        img = new Image;
        img.src = 'img/collision.png';
      } else {
        img = window.buzz.resources[this.tileset];
      }
      mapContainer = document.createElement('div');
      if (this.type === c.mapType.collision) {
        tilesPerRow = img.width / 32;
      } else {
        tilesPerRow = img.width / this.tileSize;
      }
      mapContainer.className = 'cider-map';
      mapContainer.id = "cider-layer-" + this.id;
      mcs = mapContainer.style;
      mcs.position = 'absolute';
      mcs.zIndex = this.zIndex || 1;
      mcs.left = '0px';
      mcs.top = '0px';
      _ref = this.data;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        if (row) {
          for (j = _j = 0, _len1 = row.length; _j < _len1; j = ++_j) {
            col = row[j];
            this.renderTile(mapContainer, row[j], i, j, img, tilesPerRow);
          }
        }
      }
      return mapContainer;
    };

    Layer.prototype.renderTile = function(mapContainer, tile, row, col, img, tilesPerRow) {
      var currentColumn, currentRow, offX, offY, tcStyle, tileContainer, tileSize, xPos, yPos;
      if (!tile) {
        return;
      }
      tileSize = this.tileSize;
      xPos = col * tileSize;
      yPos = row * tileSize;
      tileContainer = document.createElement('div');
      tcStyle = tileContainer.style;
      currentRow = Math.ceil(tile / tilesPerRow) - 1;
      currentColumn = tile % tilesPerRow - 1;
      if (this.type === c.mapType.collision) {
        offX = -(currentColumn * 32) * (tileSize / 32);
        offY = -(currentRow * 32) * (tileSize / 32);
      } else {
        offX = -(currentColumn * tileSize);
        offY = -(currentRow * tileSize);
      }
      tcStyle.width = tcStyle.height = "" + tileSize + "px";
      tcStyle.position = 'absolute';
      tcStyle.left = "" + xPos + "px";
      tcStyle.top = "" + yPos + "px";
      tcStyle.backgroundImage = "url(" + img.src + ")";
      tcStyle.zIndex = this.zIndex || 1;
      if (this.type === c.mapType.collision) {
        tcStyle.backgroundSize = "" + (256 * (tileSize / 32)) + "px";
        tcStyle.backgroundPosition = "" + offX + "px " + offY + "px";
      } else {
        tcStyle.backgroundSize = 'auto';
        tcStyle.backgroundPosition = "" + offX + "px " + offY + "px";
      }
      return mapContainer.appendChild(tileContainer);
    };

    return Layer;

  })();

  /* --------------------------------------------
       Begin layerOptions.coffee
  --------------------------------------------
  */


  LayerOptions = (function() {

    LayerOptions.prototype._template = function(layer) {
      return $("<h2>Layer Options</h2>\n<ul class=\"options-container\">\n	<li class=\"group\">\n		<div class=\"key\">Name</div>\n		<div class=\"val\">\n			<input value=\"" + (layer.name ? layer.name : void 0) + "\" type=\"text\" class=\"name\">\n		</div>\n	</li>\n	<li class=\"group\">\n		<div class=\"key\">Type</div>\n		<div class=\"val\">\n			<select class=\"type\">\n				<option " + (layer.type === c.mapType.collision ? 'selected' : void 0) + " value=\"" + c.mapType.collision + "\">collision</option>\n				<option " + (layer.type === c.mapType.regular ? 'selected' : void 0) + " value=\"" + c.mapType.regular + "\">regular</option>\n			</select>\n		</div>\n	</li>\n	<li class=\"group\">\n		<div class=\"key\">Tile Size</div>\n		<div class=\"val\">\n			<input value=\"" + (layer.tileSize ? layer.tileSize : void 0) + "\" type=\"number\" class=\"tileSize\">\n		</div>\n	</li>\n	<li class=\"group\">\n		<div class=\"key\">Distance</div>\n		<div class=\"val\">\n			<input value=\"" + (layer.distance ? layer.distance : void 0) + "\" type=\"number\" class=\"distance\">\n		</div>\n	</li>\n	<li class=\"tileset-container group\">\n		<div class=\"key\">Tileset</div>\n		<div class=\"val\">\n			<select class=\"tileset\"></select>\n		</div>\n	</li>\n	<li class=\"group\">\n		<div class=\"key\">zIndex</div>\n		<div class=\"val\">\n			<input value=\"" + (layer.zIndex ? layer.zIndex : void 0) + "\" type=\"number\" class=\"zIndex\">\n		</div>\n	</li>\n</ul>");
    };

    function LayerOptions() {
      this.updateLayerZindex = __bind(this.updateLayerZindex, this);

      this.updateLayerTileset = __bind(this.updateLayerTileset, this);

      this.updateLayerDistance = __bind(this.updateLayerDistance, this);

      this.updateLayerTileSize = __bind(this.updateLayerTileSize, this);

      this.updateLayerType = __bind(this.updateLayerType, this);

      this.updateLayerName = __bind(this.updateLayerName, this);

      this.unload = __bind(this.unload, this);

      this.load = __bind(this.load, this);

      this.bindEvents = __bind(this.bindEvents, this);
      this.el = $('#selected-options');
      this.bindEvents();
    }

    LayerOptions.prototype.bindEvents = function() {
      this.el.on('change', '.name', this.updateLayerName);
      this.el.on('change', '.type', this.updateLayerType);
      this.el.on('change', '.tileSize', this.updateLayerTileSize);
      this.el.on('change', '.distance', this.updateLayerDistance);
      this.el.on('change', '.tileset', this.updateLayerTileset);
      return this.el.on('change', '.zIndex', this.updateLayerZindex);
    };

    LayerOptions.prototype.load = function(layer) {
      var tilesetHtml,
        _this = this;
      this.layer = layer;
      if (!this.layer) {
        throw 'LayerOptions requires a layer';
      }
      this.el.html(this._template(layer));
      if (this.layer.type === c.mapType.collision) {
        this.el.find('.tileset-container').hide();
      }
      tilesetHtml = '<option value="">Select…</option>' + _.reduce(window.buzz.resources, function(memo, resource, name) {
        return memo + ("<option " + (_this.layer.tilesetUrl === resource.src ? 'selected' : void 0) + " value=\"" + resource.src + "\">" + name + "</option>");
      }, '');
      return this.el.find('.tileset').html(tilesetHtml);
    };

    LayerOptions.prototype.unload = function(layer) {
      if (layer !== this.layer) {
        return;
      }
      this.layer = null;
      return this.el.html('');
    };

    LayerOptions.prototype.updateLayerName = function(e) {
      var changed;
      changed = $(e.target);
      this.layer.name = changed.val();
      return this.layer.listEl.trigger('updateName');
    };

    LayerOptions.prototype.updateLayerType = function(e) {
      var changed, type;
      changed = $(e.target);
      type = parseInt(changed.val(), 10);
      if (type === c.mapType.collision) {
        $('.tileset-container').hide();
        this.layer.tileset = 'cider collision';
        this.layer.tilesetUrl = 'img/collision.png';
      } else {
        $('.tileset-container').show();
      }
      this.layer.type = type;
      window.buzz.renderer.switchLayer();
      return window.buzz.renderer.renderLayers();
    };

    LayerOptions.prototype.updateLayerTileSize = function(e) {
      var changed;
      changed = $(e.target);
      this.layer.tileSize = parseInt(changed.val(), 10);
      window.buzz.renderer.switchLayer();
      return window.buzz.renderer.renderLayers();
    };

    LayerOptions.prototype.updateLayerDistance = function(e) {
      var changed;
      changed = $(e.target);
      return this.layer.distance = parseInt(changed.val(), 10);
    };

    LayerOptions.prototype.updateLayerTileset = function(e) {
      this.layer.tileset = this.el.find(".tileset option[value=\"" + ($(e.target).val()) + "\"]").text();
      this.layer.tilesetUrl = $(e.target).val();
      window.buzz.renderer.switchLayer();
      return window.buzz.renderer.renderLayers();
    };

    LayerOptions.prototype.updateLayerZindex = function(e) {
      var changed;
      changed = $(e.target);
      this.layer.zIndex = parseInt(changed.val(), 10);
      return window.buzz.renderer.renderLayers();
    };

    return LayerOptions;

  })();

  /* --------------------------------------------
       Begin levelOptions.coffee
  --------------------------------------------
  */


  LevelOptions = (function() {

    function LevelOptions() {
      this.updateLevelSize = __bind(this.updateLevelSize, this);

      this.updateLevelTileSize = __bind(this.updateLevelTileSize, this);

      this.load = __bind(this.load, this);

      this.bindEvents = __bind(this.bindEvents, this);
      this.el = $('#level-options');
      this.bindEvents();
    }

    LevelOptions.prototype.bindEvents = function() {
      this.el.on('change', '.tileSize', this.updateLevelTileSize);
      return this.el.on('change', '.x, .y', this.updateLevelSize);
    };

    LevelOptions.prototype.load = function(level) {
      this.level = level;
      if (!this.level) {
        throw 'LevelOptions requires a level';
      }
      this.el.find('.tileSize').val(this.level.tileSize);
      this.el.find('.x').val(this.level.size.x);
      return this.el.find('.y').val(this.level.size.y);
    };

    LevelOptions.prototype.updateLevelTileSize = function(e) {
      var changed;
      changed = $(e.target);
      this.level.tileSize = parseInt(changed.val(), 10);
      this.level.setPxSize();
      return window.buzz.renderer.updateLevel();
    };

    LevelOptions.prototype.updateLevelSize = function(e) {
      this.level.size = {
        x: parseInt(this.el.find('.x').val(), 10),
        y: parseInt(this.el.find('.y').val(), 10)
      };
      this.level.setPxSize();
      return window.buzz.renderer.updateLevel();
    };

    return LevelOptions;

  })();

  /* --------------------------------------------
       Begin buzz.coffee
  --------------------------------------------
  */


  $(document).ready(function() {
    var kicker;
    window.buzz = {
      layers: {},
      zoom: 1,
      layerOptions: new LayerOptions(),
      levelOptions: new LevelOptions(),
      level: new Level(),
      renderer: new Renderer(),
      tilePicker: new TilePicker(),
      Layer: Layer
    };
    $.ajax({
      url: 'config.json',
      success: function(config) {
        if (!(config && config.resources)) {
          console.error('Set up config.json (in the buzz directory) with appropriate values. An appropriate config file looks something like this:', {
            "resourcesPrefix": "../",
            "resources": {
              "box": "img/box.png",
              "bg tiles": "img/bgtiles.png",
              "fg tiles": "img/fgtiles.png",
              "stars": "img/stars.gif"
            }
          });
        }
        new Loader(kicker, config.resources, config.resourcesPrefix);
        return window.buzz.resources = config.resources;
      }
    });
    return kicker = {
      ready: function() {
        console.log('all loaded', window.buzz.resources);
        window.buzz.layerList = new LayerList();
        window.buzz.levelOptions.load(window.buzz.level);
        return window.buzz.renderer.loadLevel(window.buzz.level);
      }
    };
  });

}).call(this);
