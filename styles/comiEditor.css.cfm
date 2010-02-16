body { margin: 0; padding: 0; font-family: arial; font-size: 14px; }

.navigator, .editor { padding-top: 1em; }

.fileManager { min-width: 250px; max-width: 10%; float: left; }
.fileManager a { display: block; padding: 2px 5px 4px; }
.fileManager li { position: relative; }
.fileManager li:hover .menu, .fileManager .menu:hover { display: block; }
.fileManager .menu { position: absolute; display: none; background: #fff; border: solid 1px #ccc; right: -38%; width: 40%; top: -50%; z-index: 1000; }

.editor { margin-right: 200px; overflow: auto; position: relative; z-index: 100; }

a:hover { color: #009; font-weight: bold; }
a.delete:hover { color: #600; }
a.file:hover, a.dir:hover, h3 a:hover { color: #040; }

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

ul { list-style: none; margin: 0; padding: 0;}
