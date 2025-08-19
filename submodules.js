const file = Bun.file("./prf.elements/dist/lib/prf.elements.cjs.js");
await Bun.write("./src/_includes/js/prf.elements.js", file);
