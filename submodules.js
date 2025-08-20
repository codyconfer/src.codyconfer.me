import { paint, asciicodes } from './ascii.js'

const _path = '.'
const _src = `${_path}/src`
const _lib = 'dist/lib'
const _js = `${_src}/_includes/js`

export const lmnt = {
  path: `${_path}/lmnt`,
  artifact: `lmnt.cjs.js`,
  filename: 'lmnt.js'
}

const submodules = [
  lmnt
]

for (const submodule of submodules) {
  const name = paint('lmnt', asciicodes.cyan, asciicodes.bright)
  const filename = paint(submodule.filename, asciicodes.green)
  const artifactPath = paint(`${lmnt.path}/${_lib}/`, asciicodes.dim)
  const artifact = paint(submodule.artifact, asciicodes.cyan)
  console.log(
    `copying ${name} ${artifactPath}${artifact} => ${filename}`
  )
  const file = Bun.file(`${lmnt.path}/${_lib}/${submodule.artifact}`)
  await Bun.write(`${_js}/${submodule.filename}`, file)
}
