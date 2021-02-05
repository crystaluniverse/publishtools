module installers

import os
import myconfig
import process
import gittools
import texttools
import publisher

pub fn wiki_cleanup(name string, conf &myconfig.ConfigRoot) ? {
	codepath := conf.paths.code

	mut gt := gittools.new(codepath) or { return error('ERROR: cannot load gittools:$err') }

	mut repo := gt.repo_get(name: name) or { return error('ERROR: cannot load gittools:$err') }
	println(' - cleanup wiki $repo.path')

	gitignore := '
	src/errors.md
	session_data/*
	book
	book/
	boo/*
	"https*
	https*
	http*
	"*
	docshttp*
	.vscode
	'
	os.write_file('$repo.path/.gitignore', texttools.dedent(gitignore)) or {
		return error('cannot write to $repo.path/.gitignore\n$err')
	}

	script_cleanup := '

	set -ex
	
	cd $repo.path

	git checkout development

	rm -rf .vscode
	rm -rf .cache		
	rm -rf modules
	rm -f .installed
	'

	process.execute_stdout(script_cleanup) or { return error('cannot cleanup for ${name}.\n$err') }

	script_merge_master := '
	git checkout master
	git merge development
	set +e
	git add . -A
	git commit -m "installer cleanup"
	set -e
	git push
	git checkout development
	'

	process.execute_stdout(script_merge_master) or {
		return error('cannot merge_master for ${name}.\n$err')
	}

	mut publisher := publisher.new(conf.root) or { panic('cannot init publisher. $err') }
	for mut site in publisher.sites {
		site.files_process(mut &publisher) or { panic(err) }
		site.load(mut &publisher) // will check the errors
	}
}
