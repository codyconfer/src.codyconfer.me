import {asciicodes, paint} from './ascii.js'
import { readdir,mkdir } from "node:fs/promises";


const _path = '.'
const _src = `${_path}/src`
const _includes = `${_src}/_includes`
const _js = `${_includes}/js`
const _styles = `${_includes}/styles`

const submodules = [
  {
    name: 'lmnt',
    inDir: `${_path}/lmnt/dist/lib`,
    outDir: `${_includes}/lmnt`
  }
]

const copyFile = async ({name, inDir, outDir}) => {
  const fpkg = paint(name, asciicodes.cyan, asciicodes.bright)
  const fInFile = paint(`${inDir} =>`, asciicodes.dim)
  const fOutFile = paint(outDir, asciicodes.dimgray)
  const inFile = Bun.file(inDir)
  console.log(`copying ${fpkg} ${fInFile} ${fOutFile}`)
  if (!inFile.exists()) {
    console.error(paint('warn! artifact not found. skipping', asciicodes.yellow, asciicodes.bright))
  }
  const outFile = Bun.file(outDir)
  await Bun.write(outFile, inFile)
  if (!outFile.exists()) {
    console.error(paint('error! file not copied', asciicodes.red, asciicodes.bright))
  }
}

const copyDir = async ({name, inDir, outDir}) => {
  await mkdir(`${outDir}`, { recursive: true })
  const items = await readdir(inDir, { recursive: true })
  for (const i of items) {
    const item = i.replace(/\\/g, '/')
    const file = {
      name,
      inDir: `${inDir}/${item}`,
      outDir: `${outDir}/${item}`
    }
    if (await Bun.file(file.inDir).exists())
      await copyFile(file)
  }
}

console.log(paint('copying submodules', asciicodes.magenta))
for (const submodule of submodules)
  if (await Bun.file(submodule.inDir).exists())
    await copyFile(submodule)
  else
    await copyDir(submodule)

console.log(`${paint(`ok!`, asciicodes.green, asciicodes.bright)}`)
