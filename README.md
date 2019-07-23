# docker-jsonnet

Docker image for [google/jsonnet](http://jsonnet.org/) - The data templating language.
Includes [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler) with auto-resolving jsonnet dependencies.
 
# Usage
Mount the jsonnet files to `/src` in the container. 
Existing `jsonnetfile.json` dependencies will be installed and the jsonnet file compiled.
If the `jsonnetfile.json` file is not directly located in the mounted folder
you can change the basedir with the BASEDIR argument.  All entrypoint commands
(`jb`, `jsonnet`, `jsonnetfmt`) will be relative to `/src/${BASEDIR}` (or `${BASEDIR}` if
specified as absolute path).

```
docker run --rm -it -v $(pwd):/src pagerinc/jsonnet ${ARGS}
```
