import CleanCSS from "clean-css";
import htmlmin from "html-minifier-terser";
import markdownIt from "markdown-it";
import markdownItAttrs from 'markdown-it-attrs'
import {minify} from "terser";
import syntaxHighlight from '@11ty/eleventy-plugin-syntaxhighlight'


const _path = 'src'

export default async function (eleventyConfig) {
  eleventyConfig.setInputDirectory(_path)

  eleventyConfig.addPassthroughCopy({'prf.elements/dist/lib/prf.elements.umd.js': 'prf.elements.js'})
  eleventyConfig.addPassthroughCopy('src/assets/*')

  let options = {
    html: true,
    breaks: true,
    linkify: true,
  }
  const md = markdownIt(options).use(markdownItAttrs)
  eleventyConfig.setLibrary("md", )

  eleventyConfig.addFilter("md", function (code) {
    try {
      return md.render(code)
    } catch (err) {
      console.error("Markdown error: ", err);
    }
  })
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
  })
  eleventyConfig.addTransform("htmlmin", function (content) {
    if ((this.page.outputPath || "").endsWith(".html"))
      return htmlmin.minify(content, {
        useShortDoctype: true,
        removeComments: true,
        collapseWhitespace: true,
      })
    return content;
  })

  eleventyConfig.addPlugin(syntaxHighlight)
}
