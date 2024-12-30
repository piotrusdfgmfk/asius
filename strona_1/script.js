var CHAR_SPACE = 1;
var CHAR_WIDTH = 5;
var CHAR_HEIGHT = 5;
var CHAR_COUNT = 8;
var BUF_CHAR_COUNT = 128;
var DM_WIDTH = CHAR_COUNT * (CHAR_WIDTH+CHAR_SPACE);
var BUF_WIDTH = BUF_CHAR_COUNT * (CHAR_WIDTH+CHAR_SPACE);
var DM_HEIGHT = CHAR_HEIGHT;
var DOT_RADIUS = 3;
var DOT_PAD = 1;
var OUT_PAD = 5;
var LED_COLOR = "#1e4";
var TIME_STEP = 1.0 / 15;
var FONT = Object.freeze({
	A: [ 0xE, 0x11, 0x1F, 0x11, 0x11 ],
	B: [ 0x1E, 0x11, 0x1E, 0x11, 0x1E ],
	C: [ 0xF, 0x10, 0x10, 0x10, 0xF ],
	D: [ 0x1E, 0x11, 0x11, 0x11, 0x1E ],
	E: [ 0x1F, 0x10, 0x1E, 0x10, 0x1F ],
	F: [ 0x1F, 0x10, 0x1E, 0x10, 0x10 ],
	G: [ 0xF, 0x10, 0x17, 0x11, 0xF ],
	H: [ 0x11, 0x11, 0x1F, 0x11, 0x11 ],
	I: [ 0xE, 0x4, 0x4, 0x4, 0xE ],
	J: [ 0x7, 0x2, 0x2, 0x12, 0xC ],
	K: [ 0x11, 0x12, 0x1C, 0x12, 0x11 ],
	L: [ 0x10, 0x10, 0x10, 0x10, 0x1F ],
	M: [ 0x11, 0x1B, 0x15, 0x11, 0x11 ],
	N: [ 0x11, 0x19, 0x15, 0x13, 0x11 ],
	O: [ 0xE, 0x11, 0x11, 0x11, 0xE ],
	P: [ 0x1E, 0x11, 0x1E, 0x10, 0x10 ],
	Q: [ 0xE, 0x11, 0x15, 0x13, 0xF ],
	R: [ 0x1E, 0x11, 0x1E, 0x11, 0x11 ],
	S: [ 0xF, 0x10, 0xE, 0x1, 0x1E ],
	T: [ 0x1F, 0x4, 0x4, 0x4, 0x4 ],
	U: [ 0x11, 0x11, 0x11, 0x11, 0xE ],
	V: [ 0x11, 0x11, 0xA, 0xA, 0x4 ],
	W: [ 0x11, 0x11, 0x15, 0x1B, 0x11 ],
	X: [ 0x11, 0xA, 0x4, 0xA, 0x11 ],
	Y: [ 0x11, 0x11, 0xA, 0x4, 0x4 ],
	Z: [ 0x1F, 0x2, 0x4, 0x8, 0x1F ],
	'0': [ 0x1F, 0x13, 0x15, 0x19, 0x1F ],
	'1': [ 0x4, 0xC, 0x4, 0x4, 0xE ],
	'2': [ 0x1F, 0x01, 0x1F, 0x10, 0x1F ],
	'3': [ 0x1F, 0x01, 0xF, 0x01, 0x1F ],
	'4': [ 0x11, 0x11, 0x1F, 0x01, 0x01 ],
	'5': [ 0x1F, 0x10, 0x1F, 0x01, 0x1F ],
	'6': [ 0x1F, 0x10, 0x1F, 0x11, 0x1F ],
	'7': [ 0x1F, 0x01, 0x7, 0x01, 0x01 ],
	'8': [ 0x1F, 0x11, 0x1F, 0x11, 0x1F ],
	'9': [ 0x1F, 0x11, 0x1F, 0x01, 0x1F ],
	'!': [ 0xE, 0xE, 0x4, 0x00, 0x4 ],
	'?': [ 0x1F, 0x11, 0x7, 0x00, 0x4 ],
	':': [ 0x0, 0x4, 0x0, 0x4, 0x0 ],
	';': [ 0x0, 0x4, 0x0, 0x4, 0x8 ],
	',': [ 0x0, 0x0, 0x0, 0x4, 0x8 ],
	'.': [ 0x0, 0x0, 0x0, 0x0, 0x8 ],
});

function lerp(a, b, t) {
	return (1 - t) * a + b * t;
}

function Display(canvas, update, maxFrames) {
	this.canvas = canvas || document.createElement("canvas");
	this.ctx = this.canvas.getContext("2d");
	this.mat = new Array(BUF_WIDTH * DM_HEIGHT);
	
	// Update function
	this.update = update || (function(d) {});
	this.frame = 0;
	this.maxFrames = maxFrames || 100;
	
	this.set = function(x, y, v) {
		v = v || false;
		var i = x + y * BUF_WIDTH;
		this.mat[i] = v;
	};
	
	this.sprite = function(x, y, image) {
		if (!image) return;
		for (var j = 0; j < 5; j++) {
			var row = image[j];
			for (var i = 0; i < 5; i++) {
				var col = (row >> (4-i)) & 0b01;
				var tx = (x + i);
				var ty = (y + j);
				if (tx < 0 || tx >= BUF_WIDTH || ty < 0 || ty >= DM_HEIGHT) continue;
				if (col === 1) {
					this.set(tx, ty, true);
				}
			}
		}
	};
	
	this.clear = function() {
		for (var i = 0; i < this.mat.length; i++)
			this.mat[i] = false;
	}
	
	this.text = function(x, y, txt) {
		var space = CHAR_SPACE;
		txt = txt.toUpperCase();
		var ox = 0;
		for (var i = 0; i < txt.length; i++) {
			this.sprite(x + ox, y, FONT[txt.charAt(i)]);
			ox += space + CHAR_WIDTH;
		}
	};
	
	this.textCenter = function(txt) {
		let tw = ~~((CHAR_SPACE * txt.length-1) + (txt.length * CHAR_WIDTH) * 0.5);
		this.text(~~(DM_WIDTH / 2) - tw, 0, txt);
	};
	
	this.invert = function() {
		for (var i = 0; i < this.mat.length; i++)
			this.mat[i] = !this.mat[i];
	};
	
	this.scroll = function(speed) {
		var oldm = this.mat.slice();
		for (var row = 0; row < DM_HEIGHT; row++) {
			for (var x = 0; x < BUF_WIDTH-1; x++) {
				if (x+speed > BUF_WIDTH || x+speed < 0) continue;
				if (row < 0 || row > DM_HEIGHT) continue;
				var ti = (x+speed) + row * BUF_WIDTH;
				var si = x + row * BUF_WIDTH;
				this.mat[ti] = oldm[si];
			}
		}
	};
	
	this.redraw = function() {
		var ctx = this.ctx;
		var pad = DOT_PAD * 2;
		var rad = (DOT_RADIUS+pad/2);
		this.canvas.width = (DM_WIDTH * rad * 2) + OUT_PAD*2;
		this.canvas.height = (DM_HEIGHT * rad * 2) + OUT_PAD*2;

		ctx.fillStyle = "#000";
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		for (var y = 0; y < DM_HEIGHT; y++) {
			for (var x = 0; x < DM_WIDTH; x++) {
				var dx = x * rad * 2 + OUT_PAD,
					dy = y * rad * 2 + OUT_PAD;
				var idx = x + y * BUF_WIDTH;
				
				ctx.fillStyle = "#222";
				ctx.beginPath();
				ctx.arc(dx + rad, dy + rad, DOT_RADIUS, 0, Math.PI * 2);
				ctx.fill();
				
				if (this.mat[idx]) {
					ctx.fillStyle = LED_COLOR;
					ctx.shadowColor = LED_COLOR;
					ctx.shadowBlur = rad + OUT_PAD;
					ctx.shadowOffsetX = 0;
					ctx.shadowOffsetY = 0;
					ctx.beginPath();
					ctx.arc(dx + rad, dy + rad, DOT_RADIUS, 0, Math.PI * 2);
					ctx.fill();
					ctx.shadowBlur = 0;
				}
			}
		}
	};
	
	this.start = function() {
		var that = this;
		setInterval(function() {
			that.redraw();
			that.update(that, that.frame);
			that.frame++;
			that.frame = that.frame % that.maxFrames;
		}, TIME_STEP * 1000);
	};
}

var canvas = document.getElementById("display");
var ctx = canvas.getContext("2d");

function inRange(v, a, b) {
	return v >= a && v < b;
}

function pingPong(i, min, max) {
	var range = max - min;
    return min + Math.abs(((i + range) % (range * 2)) - range);
}

var tx = DM_WIDTH;
var clr = 1.0;
var t = 0;
function sequence(d, f) {
	if (f == 0) {
		clr = 1.0;
		tx = DM_WIDTH;
		d.clear();
		d.textCenter("ROMPER");
	} else if (inRange(f, 0, 50)) {
		if (f % 4 == 0) d.invert();
	} else if (f == 51) {
		d.clear();
		d.text(tx, 0, "ASIUS");
	} else if (inRange(f, 51, 100)) {
		if (tx > 0) d.scroll(-1);
	} else if (inRange(f, 150, 200)) {
		for (var i = 0; i < DM_HEIGHT; i++)
			d.set(DM_WIDTH, i, true);
		d.scroll(-1);
	} else if (inRange(f, 201, 300)) {
		var t = new Date().toLocaleTimeString('en-US', { 
				hour12: false, 
				hour: "numeric", 
				minute: "numeric",
				second: "numeric"
		});
		d.clear();
		d.text(0, 0, t);
	}
}

var d = new Display(canvas, sequence, 300);
d.start();