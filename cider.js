// Generated by CoffeeScript 1.4.0
(function() {
  var Cider, Clock, Entity, Game, GameController, Level, Map,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    _this = this;

  Clock = (function() {

    Clock.prototype.maxStep = 50;

    Clock.prototype.timeScale = 1;

    function Clock(target) {
      this.target = target != null ? target : 0;
      this.delta = __bind(this.delta, this);

      this.tick = __bind(this.tick, this);

      this.reset = __bind(this.reset, this);

      this.set = __bind(this.set, this);

      this.base = c.Clock.time;
      this.last = c.Clock.time;
    }

    Clock.prototype.set = function(target) {
      this.target = target || 0;
      return this.base = c.Clock.time;
    };

    Clock.prototype.reset = function() {
      return this.base = c.Clock.time;
    };

    Clock.prototype.tick = function() {
      var delta;
      delta = c.Clock.time - this.last;
      this.last = c.Clock.time;
      return delta;
    };

    Clock.prototype.delta = function() {
      return c.Clock.time - this.base - this.target;
    };

    return Clock;

  })();

  Clock.maxStep = 50;

  Clock.timeScale = 1;

  Clock.time = 0;

  Clock._last = 0;

  Clock.step = function() {
    var current, delta;
    current = Date.now();
    delta = current - c.Clock._last;
    c.Clock.time += Math.min(delta, c.Clock.maxStep) * c.Clock.timeScale;
    return c.Clock._last = current;
  };

  /* --------------------------------------------
       Begin map.coffee
  --------------------------------------------
  */


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
      c.extend(this, options);
      if (this.type !== c.mapType.collision && !this.tileset) {
        throw new Error('Non-collision Cider Maps require a tileset');
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
        x: 100,
        y: 50
      };
      this.tileSize = 16;
      c.extend(this, options);
      if (!((this.maps != null) && this.maps.length)) {
        throw new Error('Cider Levels require at least one map');
      }
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
      return map.tileSize = this.tileSize;
    };

    return Level;

  })();

  /* --------------------------------------------
       Begin gamecontroller.coffee
  --------------------------------------------
  */


  GameController = (function() {

    function GameController() {
      this.holding = __bind(this.holding, this);

      this.triggered = __bind(this.triggered, this);

      this._keyup = __bind(this._keyup, this);

      this._keydown = __bind(this._keydown, this);

      this.update = __bind(this.update, this);
      this._triggered = [];
      this._holding = [];
    }

    GameController.prototype.update = function() {
      return this._triggered = [];
    };

    GameController.prototype._keydown = function(e) {};

    GameController.prototype._keyup = function(e) {};

    GameController.prototype.triggered = function(action) {};

    GameController.prototype.holding = function(action) {};

    GameController.prototype._map = {
      'm1': -1,
      'm2': -3,
      'mup': -4,
      'mdown': -5,
      'backspace': 8,
      'tab': 9,
      'enter': 13,
      'pause': 19,
      'caps': 20,
      'esc': 27,
      'space': 32,
      'page up': 33,
      'page down': 34,
      'end': 35,
      'home': 36,
      'left': 37,
      'up': 38,
      'right': 39,
      'down': 40,
      'insert': 45,
      'delete': 46,
      '_0': 48,
      '_1': 49,
      '_2': 50,
      '_3': 51,
      '_4': 52,
      '_5': 53,
      '_6': 54,
      '_7': 55,
      '_8': 56,
      '_9': 57,
      'a': 65,
      'b': 66,
      'c': 67,
      'd': 68,
      'e': 69,
      'f': 70,
      'g': 71,
      'h': 72,
      'i': 73,
      'j': 74,
      'k': 75,
      'l': 76,
      'm': 77,
      'n': 78,
      'o': 79,
      'p': 80,
      'q': 81,
      'r': 82,
      's': 83,
      't': 84,
      'u': 85,
      'v': 86,
      'w': 87,
      'x': 88,
      'y': 89,
      'z': 90,
      'num 0': 96,
      'numpad 1': 97,
      'numpad 2': 98,
      'numpad 3': 99,
      'numpad 4': 100,
      'numpad 5': 101,
      'numpad 6': 102,
      'numpad 7': 103,
      'numpad 8': 104,
      'numpad 9': 105,
      'multiply': 106,
      'add': 107,
      'subtract': 109,
      'decimal': 110,
      'divide': 111,
      'f1': 112,
      'f2': 113,
      'f3': 114,
      'f4': 115,
      'f5': 116,
      'f6': 117,
      'f7': 118,
      'f8': 119,
      'f9': 120,
      'f10': 121,
      'f11': 122,
      'f12': 123,
      'shift': 16,
      'ctrl': 17,
      'alt': 18,
      'plus': 187,
      'comma': 188,
      'minus': 189,
      'period': 190
    };

    return GameController;

  })();

  /* --------------------------------------------
       Begin game.coffee
  --------------------------------------------
  */


  Game = (function() {

    function Game(options) {
      if (options == null) {
        options = {};
      }
      this.destroyEntity = __bind(this.destroyEntity, this);

      this.createEntity = __bind(this.createEntity, this);

      this.drawEntities = __bind(this.drawEntities, this);

      this.updateEntities = __bind(this.updateEntities, this);

      this.draw = __bind(this.draw, this);

      this.update = __bind(this.update, this);

      this.run = __bind(this.run, this);

      this.unpause = __bind(this.unpause, this);

      this.pause = __bind(this.pause, this);

      this.createMapTile = __bind(this.createMapTile, this);

      this.loadMap = __bind(this.loadMap, this);

      this.loadLevel = __bind(this.loadLevel, this);

      this.positionCamera = __bind(this.positionCamera, this);

      this.initializeElements = __bind(this.initializeElements, this);

      this.createElements = __bind(this.createElements, this);

      this.initializeCollisionListeners = __bind(this.initializeCollisionListeners, this);

      this.initializeDebugMode = __bind(this.initializeDebugMode, this);

      this._entityIdCounter = 1;
      this.clock = new c.Clock;
      this.entities = {};
      this.resources = {};
      this.cSize = {
        x: 640,
        y: 320
      };
      this.tagName = 'div';
      this.className = '';
      this.id = 'cider-camera';
      this.gravity = {
        x: 0,
        y: 9.8
      };
      this.cPos = {
        x: 0,
        y: 0
      };
      this.debug = false;
      this.debugDraw = false;
      c.extend(this, options);
      this.bodyTrash = [];
      this.createElements();
      this.initializeElements();
      if (this.debug) {
        this.initializeDebugMode();
        this.lastFrameStart = Date.now();
      }
      this.run();
    }

    Game.prototype.initializeDebugMode = function() {
      var style;
      this.debugEl = document.createElement('div');
      style = this.debugEl.style;
      this.debugEl.id = 'cider-debug';
      style.position = 'absolute';
      style.bottom = '0px';
      style.right = '0px';
      return document.body.appendChild(this.debugEl);
    };

    Game.prototype.initializeCollisionListeners = function() {
      var listener,
        _this = this;
      listener = new b2ContactListener;
      listener.PostSolve = function(contact, impulse) {
        var eA, eB;
        eA = _this.entities[contact.GetFixtureA().GetBody().GetUserData()];
        eB = _this.entities[contact.GetFixtureB().GetBody().GetUserData()];
        if (eA && eB) {
          eA.collidePost(eB, impulse.normalImpulses[0]);
          return eB.collidePost(eA, impulse.normalImpulses[0]);
        }
      };
      return this.world.SetContactListener(listener);
    };

    Game.prototype.createElements = function() {
      var cameraEl, el;
      cameraEl = document.createElement('div');
      cameraEl.id = this.id;
      cameraEl.className = this.className;
      this.cameraEl = cameraEl;
      el = document.createElement(this.tagName);
      el.id = 'cider-world';
      return this.el = el;
    };

    Game.prototype.initializeElements = function() {
      var cEs, es;
      cEs = this.cameraEl.style;
      cEs.width = "" + this.cSize.x + "px";
      cEs.height = "" + this.cSize.y + "px";
      cEs.overflow = 'hidden';
      cEs.position = 'relative';
      es = this.el.style;
      es.overflow = 'hidden';
      es.position = 'absolute';
      document.body.appendChild(this.cameraEl);
      return this.cameraEl.appendChild(this.el);
    };

    Game.prototype.positionCamera = function() {
      var es;
      if (!this.currentLevel) {
        return;
      }
      es = this.el.style;
      if (this.cPos.x < 0) {
        this.cPos.x = 0;
      }
      if (this.cPos.x > this.currentLevel.pxSize.x - this.cSize.x) {
        this.cPos.x = this.currentLevel.pxSize.x - this.cSize.x;
      }
      if (this.cPos.y < 0) {
        this.cPos.y = 0;
      }
      if (this.cPos.y > this.currentLevel.pxSize.y - this.cSize.y) {
        this.cPos.y = this.currentLevel.pxSize.y - this.cSize.y;
      }
      es.left = "" + (-this.cPos.x) + "px";
      return es.top = "" + (-this.cPos.y) + "px";
    };

    Game.prototype.loadLevel = function(level) {
      var debugDraw, es, map, _i, _len, _ref;
      this.world = new b2World(new b2Vec2(this.gravity.x, this.gravity.y), true);
      this.initializeCollisionListeners();
      if (this.debugDraw) {
        debugDraw = new Box2D.Dynamics.b2DebugDraw;
        debugDraw.SetSprite(document.getElementsByTagName("canvas")[0].getContext("2d"));
        debugDraw.SetDrawScale(c.b2Scale);
        debugDraw.SetFillAlpha(0.3);
        debugDraw.SetLineThickness(1);
        debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
        this.world.SetDebugDraw(debugDraw);
      }
      this.currentLevel = level;
      this.cPos = {
        x: 0,
        y: 0
      };
      _ref = level.maps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        map = _ref[_i];
        this.loadMap(map);
      }
      es = this.el.style;
      es.width = "" + (level.size.x * level.tileSize) + "px";
      return es.height = "" + (level.size.y * level.tileSize) + "px";
    };

    Game.prototype.loadMap = function(map) {
      var col, i, j, row, _i, _len, _ref, _results;
      _ref = map.data;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        _results.push((function() {
          var _j, _len1, _results1;
          _results1 = [];
          for (j = _j = 0, _len1 = row.length; _j < _len1; j = ++_j) {
            col = row[j];
            _results1.push(this.createMapTile(map, row[j], i, j));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Game.prototype.createMapTile = function(map, tile, row, col) {
      var body, bodyDef, fixtureDef, tcStyle, tileContainer, tileSize, xPos, yPos;
      if (!tile) {
        return;
      }
      tileSize = map.tileSize;
      xPos = col * tileSize;
      yPos = row * tileSize;
      bodyDef = new b2BodyDef;
      bodyDef.position = new b2Vec2((xPos + tileSize / 2) / c.b2Scale, (yPos + tileSize / 2) / c.b2Scale);
      bodyDef.type = b2Body.b2_staticBody;
      body = this.world.CreateBody(bodyDef);
      fixtureDef = new b2FixtureDef;
      fixtureDef.density = 2;
      fixtureDef.friction = 1;
      fixtureDef.restitution = 0.2;
      fixtureDef.shape = new b2PolygonShape;
      fixtureDef.shape.SetAsBox(tileSize / 2 / c.b2Scale, tileSize / 2 / c.b2Scale);
      body.CreateFixture(fixtureDef);
      tileContainer = document.createElement('div');
      tcStyle = tileContainer.style;
      tileContainer.className = 'tile';
      tcStyle.width = tcStyle.height = "" + tileSize + "px";
      tcStyle.position = 'absolute';
      tcStyle.left = "" + xPos + "px";
      tcStyle.top = "" + yPos + "px";
      return this.el.appendChild(tileContainer);
    };

    Game.prototype.pause = function() {
      return this.paused = true;
    };

    Game.prototype.unpause = function() {
      return this.paused = false;
    };

    Game.prototype.run = function() {
      c.raf(this.run);
      c.Clock.step();
      this.tick = this.clock.tick();
      if (this.paused) {
        return;
      }
      if (this.debug) {
        this.fps = Math.round(1 / ((Date.now() - this.lastFrameStart) / 1000));
        this.lastFrameStart = Date.now();
      }
      this.positionCamera();
      this.update();
      this.draw();
      if (this.debug && ~~(Math.random() * 30) === 4) {
        return this.debugEl.innerText = "" + this.fps + " FPS";
      }
    };

    Game.prototype.update = function() {
      var body, _i, _len, _ref;
      if (this.world) {
        _ref = this.bodyTrash;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          body = _ref[_i];
          this.world.DestroyBody(body);
        }
        this.world.Step(this.tick / 1000, 8, 3);
        this.world.ClearForces();
        if (this.debugDraw) {
          this.world.DrawDebugData();
        }
      }
      return this.updateEntities();
    };

    Game.prototype.draw = function() {
      return this.drawEntities();
    };

    Game.prototype.updateEntities = function() {
      var eId, entity, _ref, _results;
      _ref = this.entities;
      _results = [];
      for (eId in _ref) {
        entity = _ref[eId];
        _results.push(entity.update());
      }
      return _results;
    };

    Game.prototype.drawEntities = function() {
      var eId, entity, _ref, _results;
      _ref = this.entities;
      _results = [];
      for (eId in _ref) {
        entity = _ref[eId];
        _results.push(entity.draw());
      }
      return _results;
    };

    Game.prototype.createEntity = function(entity) {
      var eId;
      eId = "e" + (this._entityIdCounter++);
      this.entities[eId] = entity;
      return eId;
    };

    Game.prototype.destroyEntity = function(entity) {
      this.bodyTrash.push(entity.body);
      return delete this.entities[entity._entityId];
    };

    return Game;

  })();

  /* --------------------------------------------
       Begin entity.coffee
  --------------------------------------------
  */


  Entity = (function() {

    function Entity(game, options) {
      this.game = game;
      if (options == null) {
        options = {};
      }
      this.setStyle = __bind(this.setStyle, this);

      this.draw = __bind(this.draw, this);

      this._destroyElement = __bind(this._destroyElement, this);

      this.destroy = __bind(this.destroy, this);

      this.collidePost = __bind(this.collidePost, this);

      this.update = __bind(this.update, this);

      this.drawElement = __bind(this.drawElement, this);

      this.initializeElement = __bind(this.initializeElement, this);

      this.createElement = __bind(this.createElement, this);

      this.createBody = __bind(this.createBody, this);

      this._entityId = this.game.createEntity(this);
      this.tagName = 'div';
      this.className = '';
      this.id = '';
      this.pos = {
        x: 0,
        y: 0
      };
      this.vel = {
        x: 0,
        y: 0
      };
      this.size = {
        x: 0,
        y: 0
      };
      this.angle = 0;
      this.angularDamping = 0;
      this.gravityScale = 1;
      this.density = 1;
      this.restitution = 0.2;
      this.friction = 0.2;
      c.extend(this, options);
      this.createBody();
      this.createElement();
      this.initializeElement();
    }

    Entity.prototype.createBody = function() {
      var bodyDef, fixtureDef;
      bodyDef = new b2BodyDef;
      bodyDef.position = new b2Vec2((this.pos.x + this.size.x / 2) / c.b2Scale, (this.pos.y + this.size.y / 2) / c.b2Scale);
      bodyDef.type = b2Body.b2_dynamicBody;
      bodyDef.userData = this._entityId;
      bodyDef.angularDamping = this.angularDamping;
      bodyDef.gravityScale = this.gravityScale;
      this.body = this.game.world.CreateBody(bodyDef);
      fixtureDef = new b2FixtureDef;
      fixtureDef.density = this.density;
      fixtureDef.friction = this.friction;
      fixtureDef.restitution = this.restitution;
      fixtureDef.shape = new b2PolygonShape;
      fixtureDef.shape.SetAsBox(this.size.x / 2 / c.b2Scale, this.size.y / 2 / c.b2Scale);
      return this.body.CreateFixture(fixtureDef);
    };

    Entity.prototype.createElement = function() {
      var el;
      el = document.createElement(this.tagName);
      el.className = this.className;
      el.id = this.id;
      return this.el = el;
    };

    Entity.prototype.initializeElement = function() {
      var es;
      es = this.el.style;
      es.position = 'absolute';
      es.background = '#f00';
      return this.game.el.appendChild(this.el);
    };

    Entity.prototype.drawElement = function() {
      var es;
      es = this.el.style;
      es.left = "" + (this.pos.x - this.size.x / 2) + "px";
      es.top = "" + (this.pos.y - this.size.y / 2) + "px";
      es.width = "" + this.size.x + "px";
      es.height = "" + this.size.y + "px";
      return es.WebkitTransform = "rotate(" + this.angle + "deg)";
    };

    Entity.prototype.update = function() {
      var body, newPos, newVel;
      body = this.body;
      newPos = body.GetPosition();
      newVel = body.GetLinearVelocity();
      this.angle = body.GetAngle() * (180 / Math.PI);
      this.pos.x = Math.round(newPos.x * c.b2Scale);
      this.pos.y = Math.round(newPos.y * c.b2Scale);
      this.vel.x = newVel.x;
      return this.vel.y = newVel.y;
    };

    Entity.prototype.collidePost = function(other, impulse) {};

    Entity.prototype.destroy = function() {
      this._destroyElement();
      return this.game.destroyEntity(this);
    };

    Entity.prototype._destroyElement = function() {
      return this.game.el.removeChild(this.el);
    };

    Entity.prototype.draw = function() {
      return this.drawElement();
    };

    Entity.prototype.setStyle = function(prop, val) {
      return this.el.style[prop] = val;
    };

    return Entity;

  })();

  /* --------------------------------------------
       Begin cider.coffee
  --------------------------------------------
  */


  window.b2Vec2 = Box2D.Common.Math.b2Vec2;

  window.b2BodyDef = Box2D.Dynamics.b2BodyDef;

  window.b2Body = Box2D.Dynamics.b2Body;

  window.b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  window.b2Fixture = Box2D.Dynamics.b2Fixture;

  window.b2World = Box2D.Dynamics.b2World;

  window.b2MassData = Box2D.Collision.Shapes.b2MassData;

  window.b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  window.b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  window.b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  window.b2ContactListener = Box2D.Dynamics.b2ContactListener;

  Cider = {
    Game: Game,
    Entity: Entity,
    Clock: Clock,
    Level: Level,
    Map: Map,
    b2Scale: 30,
    mapType: Object.freeze({
      regular: 0,
      collision: 1
    }),
    raf: (function() {
      var func;
      func = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
        return window.setTimeout(callback, 1000 / 60);
      };
      return function(cb, el) {
        return func.apply(window, [cb, el]);
      };
    })(),
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
    },
    log: function() {
      if (window.console) {
        return console.log(Array.prototype.slice.call(arguments));
      }
    }
  };

  window.c = window.Cider = Cider;

}).call(this);
