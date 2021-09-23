# Front-end web app using Docker ![Build Status](https://github.com/Antonio-Kim/docker-react/actions/workflows/setup.yml/badge.svg)
This is a simple web application using React.js and Docker. 

## How it's setup
There are two different Dockerfiles: Dockerfile.dev, and Dockerfile. As name suggests, Dockerfile.dev
is used during Development phase, and the regular Dockerfile is used in Production. Unlike other docker
examples, this container does not use COPY, but rather uses Volume to reference the file in the directory.
Because of this, running the Docker container is slightly different than before. 

We first have to reference the local directory to the working directory in the container, using '-v $(pwd):/app', 
which is referenced at the Dockefile.dev. The pwd is the current directory that the Dockerfile.dev is currently located at. 
One issue that this will encounter is that /app/node_module is nowhere to be referenced in the local directory,
hence it needs to be reference back to node_module in the container. The way to do this is to add
'-v /app/node_moudles' before the Volume argument to bookmark the node_modules folder. Therefore, use the
following commands to run the app:
```bash
docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image>
```
But this is not necessary, and it would be painful run this command all the time when needed. This is where
docker-compose comes in. Have a look at the docker-compose.yml file and try to find out where the docker
command is mapped onto the file.

## Production Environment
As it currently stands, if you were to run the docker-compose, it would be running at Development environment, 
and have the browser communicate with development server to retrieve html and javascript, which is not appropriate
in the production. In order to issue the app in the production, you would need production server to handle this,
and this is where nginx comes in. To configure with nginx, we create new Dockerfile (without .dev this time), and
have multi-step Docker build, where the first step is building production file builds, then copying the build 
to nginx container and running the container to have production-ready environment. See Dockerfile for more
infomation.

## Using GitHub Action (and the flag on readme.md)
Similar to Circle CI and Travis CI, Github Action allows you to integrate your workflow on the repo. Why Github Action
instead of Circle CI or Travis CI? I found difficult to use Circle CI with Docker; it does not allow Docker to 
be run without next level pricing plan. Travis CI works! But I chose GitHub Action instead since it's already integrated
and easier to use. To use Travis CI instead, create ".travis.yml" file and enter in the following:
```yaml
sudo: required
language: generic
services:
  - docker

before_install:
  - docker build -t antoniok/docker-react -f Dockerfile.dev .

script:
  - docker run -e CI=true antoniok/docker-react yarn test -- --coverage
```
This is basic set up of GitHub Action file, which is created by ".github/workflows", and then create another file (you can
name it whichever you want) with .yml extension:
```yaml
name: test
on: [ push ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: before_install
        run: docker build -t antoniok/docker-react -f Dockerfile.dev .
      - name: script
        run: docker run -e CI=true antoniok/docker-react yarn test -- --coverage
```
These two are equivalent - not quite of a mapping - to the two platforms.

## Deployment
Using Travis CI, add the following lines on the bottom:
```yaml
deploy:
  provider: elasticbeanstalk
  region: "us-east-1"
  app : "<app name that you created on Elastic Beanstalk>"
  env: "<app name-env>"
  bucket_name: "<find a bucket on S3>"
  bucket_path: "<app name>"
  on:
    branch: master
  access_key_id: $AWS_ACCESS_KEY
  secret_access_key:
    secure: "$AWS_SECRET_KEY"
```