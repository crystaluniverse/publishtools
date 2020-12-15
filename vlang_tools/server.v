module main

import vweb

const (
	port = 8082
)

struct App {

pub mut:
	vweb vweb.Context // TODO embed
	cnt  int
}

fn main() {
	println('vweb example')
	vweb.run<App>(port)
}

pub fn (mut app App) init_once() {
	app.vweb.handle_static('./testcontent/site1')
}

pub fn (mut app App) index() vweb.Result {
	return app.vweb.json('{"a": 3}')
}

pub fn (mut app App) init() {
}