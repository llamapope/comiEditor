body { margin: 0; padding: 30px 0 0; font-family: arial; font-size: 14px; }

.fileManager { font-family: Cambri, arial, serif; min-width: 250px; max-width: 10%; float: left; }
.fileManager a { display: block; padding: 0px 5px 0px; }
.fileManager li { position: relative; }
.fileManager li:hover .menu, .fileManager .menu:hover { display: block; }
.fileManager .menu { position: absolute; display: none; background: #fff; border: solid 1px #ccc; right: -38%; width: 40%; top: -50%; z-index: 1000; }

.editor { margin-right: 200px; overflow: auto; position: relative; z-index: 100; }

.fileManager li:hover a { color: #009; font-weight: bold; }
.fileManager li:hover .menu a { color:#444; font-weight: normal; }
.fileManager li:hover .menu a:hover { color: #060; font-weight: bold; }
.fileManager li:hover .menu a.delete:hover { color: #600; }

.fileManager li { clear: both; }
.fileManager li:hover { background: #FFFDEF; }
.fileManager a.dir { font-weight: bold; }

h1, h2, h3, h4, h5, h6 { font-size: 1em; }

/* command panel */
.cmd, .panel { position: fixed; top: 0px; right: 0px; left: 0px; background: #eee; padding: 0 4px; line-height: 30px; }
.panel { bottom: 0px; top: 30px; text-align: right; z-index: 10; background: none; line-height: normal; }
	.panel li { padding: 0; }
	.panel h3 { margin: 1em 0 0; }

.right { float: right; z-index: 10; left: auto; }

/* message colors */
.saved { background: #E0E8EF; }
.fileManager ul:hover .saved { background-color: transparent; }
.closed { background: #E0E8EF; }

a { color: #006; text-decoration: none; }

ul { list-style: none; margin: 0; padding: 0;}
