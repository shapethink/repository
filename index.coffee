Path = require "path"

Branch = require("ampersand-state").extend
	idAttribute: "name"
	props:
		name: "string"

BranchCollection = require("ampersand-collection").extend
	model: Branch

goodBranchName = /[a-zA-Z][a-z_\/A-Z0-9-]*[a-z_A-Z0-9]/
should = require("chai").should()

shell = require "@threadmetal/shell"

module.exports = class Repository
	constructor: (path = ".") ->
		Object.defineProperties @,
			path:
				value: Path.resolve path
				writeable: false
			branches:
				value: new BranchCollection
				writeable: false

		@branches.on "add", (branch) ->
			should.exist branch.name
			branch.name.should.match goodBranchName
			shell "git branch #{branch.name}"

		@branches.on "remove", (branch) ->
			should.exist branch.name
			branch.name.should.match goodBranchName
			if @forceful
				shell "git branch -D #{branch.name}"
			else
				shell "git branch -d #{branch.name}"
