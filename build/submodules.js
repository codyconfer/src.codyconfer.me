import {asciicodes, paint} from './ascii.js'
import { readdir,mkdir,copyFile as fsCopyFile,stat } from "node:fs/promises";
import { dirname } from "node:path";


// mirrors Bun.file(p).exists(): true for existing files, false for directories
const fileExists = async (path) => {
  try {
    return (await stat(path)).isFile()
  } catch {
    return false
  }
}


const _path = '.'
const _src = `${_path}/src`
const _includes = `${_src}/_includes`

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
  const fOutFile = paint(outDir, asciicodes.gray)
  console.log(`copying ${fpkg} ${fInFile} ${fOutFile}`)
  if (!await fileExists(inDir)) {
    console.error(paint('warn! artifact not found. skipping', asciicodes.yellow, asciicodes.bright))
    return
  }
  // Bun.write created missing parents; node:fs copyFile does not
  await mkdir(dirname(outDir), { recursive: true })
  await fsCopyFile(inDir, outDir)
  if (!await fileExists(outDir)) {
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
    if (await fileExists(file.inDir))
      await copyFile(file)
  }
}

console.log(paint('copying submodules', asciicodes.magenta))
for (const submodule of submodules)
  if (await fileExists(submodule.inDir))
    await copyFile(submodule)
  else
    await copyDir(submodule)

console.log(`${paint(`ok!`, asciicodes.green, asciicodes.bright)}`)
