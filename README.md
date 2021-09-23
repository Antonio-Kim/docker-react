# Front-end web app using Docker
This is a simple web application using React.js and Docker. 

## How it's setup
There are two different Dockerfiles: Dockerfile.dev, and Dockerfile. As name suggests, Dockerfile.dev
is used during Development phase, and the regular Dockerfile is used in Production. Unlike other docker
examples, this container does not use COPY, but rather uses Volume to reference the file in the directory.
Because of this, running the Docker container is slightly different than before. We first have t reference
the local directory to the working directory in the container, using '-v $(pwd):/app', which is referenced
at the Dockefile.dev. The pwd is the current directory that the Dockerfile.dev is currently located at. 
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
and this is where nginx comes in. To configure with nginx, we create new Dockerfile (with .dev this time), and
have multi-step Docker build, where the first step is building production file builds, then copying the build 
to nginx container and running the container to have production-ready environment. See Dockerfile for more
infomation.