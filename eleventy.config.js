import CleanCSS from "clean-css";
import htmlmin from "html-minifier-terser";
import { minify } from "terser";
import syntaxHighlight from '@11ty/eleventy-plugin-syntaxhighlight'


const _path = 'src'

export default async function (eleventyConfig) {
  eleventyConfig.setInputDirectory(_path)

  eleventyConfig.addPassthroughCopy({'prf.elements/dist/lib/prf.elements.umd.js': 'prf.elements.js'})
  eleventyConfig.addPassthroughCopy('src/assets/*')

  eleventyConfig.addFilter("jsmin", async function (code) {
    try {
      const minified = await minify(code, { format: { comments: false }});
      return minified.code
    } catch (err) {
      console.error("Terser error: ", err);
    }
  })
  eleventyConfig.addFilter("cssmin", function (code) {
    return new CleanCSS({}).minify(code).styles;
  });

  eleventyConfig.addTransform("htmlmin", function (content) {
    if ((this.page.outputPath || "").endsWith(".html"))
      return htmlmin.minify(content, {
        useShortDoctype: true,
        removeComments: true,
        collapseWhitespace: true,
      })
    return content;
  });

  eleventyConfig.addPlugin(syntaxHighlight)
}
