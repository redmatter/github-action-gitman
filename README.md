# Docker Image &amp; GitHub Action for `gitman`

`gitman` documentation can be found at https://github.com/jacebrowning/gitman

If you need to use `gitman` in a CI/CD pipeline, you can use the GitHub Action provided in this repository. For local
use, to manage `gitman` dependencies, you can use the Docker image provided in this repository.

## GitHub Action

### Inputs

| Option       | Default Value | Description                                                                     |
|--------------|---------------|---------------------------------------------------------------------------------|
| `quiet`      | `false`       | Only display errors (and prompts)                                               |
| `verbose`    | `false`       | Enable verbose logging                                                          |
| `root-dir`   |               | Directory relative to the repository root, where the dependencies are installed |
| `depth`      |               | Limit the number of dependency levels                                           |
| `no-scripts` | `false`       | Skip running scripts after install                                              |

### Example Usage

```yaml
- name: Install Dependencies
  uses: redmatter/github-action-gitman@main
  with:
    root-dir: 'vendor'
```

## Docker Image

The docker image can be built using the command below.

```bash
docker build -t redmatter/gitman .
```

### How to use it?

When managing dependencies with `gitman`, you need to set up a `gitman.yml` file in your project. Once you have added
the dependencies to the `gitman.yml` file, you can run the `gitman` command to manage the dependencies.

When using the docker image to manage `gitman` dependencies, you can run the `gitman` command by mounting the project
directory as a volume.

The use of the docker image in this way can lead to file permission issues. You can avoid this by using the `--user`
option to run the container with the same privileges as your user. This way, the files created by `gitman` will
be owned by you. A typical form of the `--user` option is `--user="$(id -u):$(id -g)"`.

See a typical command below, which initializes the `gitman` dependencies. You can replace `init` with [any other
`gitman` command](https://gitman.readthedocs.io/en/latest/).

```
docker run --rm -it \
    --user="$(id -u):$(id -g)" \
    --volume="$(pwd):/project" \
    redmatter/gitman \
    init
```

### Environment Variable

For advanced use cases, you can set the following environment variables to configure the behavior of the docker image.

| Name           | Default Value | Description                                                                   |
|----------------|---------------|-------------------------------------------------------------------------------|
| `PROJECT_DIR`  | `/project`    | Directory within the container used as the project directory (root).          |
| `GITMAN_CACHE` | `/tmp`        | Directory within the container used by `gitman` for caching Git repositories. |
