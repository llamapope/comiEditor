.container { min-width: 300px; padding-top: 1em; }
.fileManager { max-width: 600px; }
.fileManager a { float: right; width: 50px; text-align: center; }

a:hover { color: #009; font-weight: bold; }
a.delete:hover { color: #600; }
a.file:hover, a.dir:hover, h3 a:hover { color: #040; }
a.file, a.dir { float: none; padding: 0 15px 0 5px; display: block; width: auto; text-align: left; }

.fileManager li { clear: both; }
.fileManager li:hover { background: #fefeea; }
.fileManager a.dir { font-weight: bold; }

h1, h2, h3, h4, h5, h6 { font-size: 1em; }

/* command panel */
.cmd { position: fixed; top: 0px; right: 0px; left: 0px; background: #eee; padding: 2px 4px; }
.cmd.right { bottom: 0px; left: auto; text-align: right; z-index: 10; background: none; }
	.cmd li { padding: 0; }
	.cmd h3 { margin: 1em 0 0; }

/* message colors */
.saved { background: #dfe; }
.closed { background: #dfa; }

a { color: #006; text-decoration: none; }

ul { list-style: none; margin: 0; padding: 0; }
