import CleanCSS from "clean-css"
import {eleventyImageTransformPlugin} from "@11ty/eleventy-img";
import fontAwesomePlugin from "@11ty/font-awesome";
import htmlmin from "html-minifier-terser"
import markdownIt from "markdown-it"
import markdownItAttrs from 'markdown-it-attrs'
import {minify} from "terser"
import {RenderPlugin} from "@11ty/eleventy"
import syntaxHighlight from '@11ty/eleventy-plugin-syntaxhighlight'


const _input = 'src'
const _assets = `${_input}/assets`
const _includes =`${_input}/_includes`
const _cdn = `${_input}/.sauce`
const _layouts = `${_includes}/layouts`


export default async function (eleventyConfig) {
  eleventyConfig.setInputDirectory(_input)
  eleventyConfig.addPassthroughCopy(`${_assets}/`)
  eleventyConfig.addPassthroughCopy(`${_cdn}/`)

  let options = {
    html: true,
    breaks: true,
    linkify: false,
  }
  const md = markdownIt(options).use(markdownItAttrs)
  eleventyConfig.setLibrary("md", md)

  eleventyConfig.addFilter("md", function (code) {
    try {
      return md.render(code)
    } catch (err) {
      console.error("Markdown error: ", err);
    }
  })
  eleventyConfig.addFilter("jsmin", async function (code) {
    try {
      const minified = await minify(code, {format: {comments: false}});
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

  eleventyConfig.addPlugin(fontAwesomePlugin)
  eleventyConfig.addPlugin(syntaxHighlight)
  eleventyConfig.addPlugin(RenderPlugin)
  eleventyConfig.addPlugin(eleventyImageTransformPlugin, {
    formats: ["webp", "jpeg"],
    htmlOptions: {
      imgAttributes: {
        loading: "lazy",
        decoding: "async",
      },
      pictureAttributes: {}
    },
  });
}
