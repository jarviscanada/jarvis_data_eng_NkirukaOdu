# Grep App
# Introduction
The grep app works like the Linux command "grep" that recursively searches through each text file line and returns a sequence of strings matching the user-specified input. Simply put, a pattern matcher app. This grep project was written using Java 8 and utilizes new Java 8 features such as Lambda, Collections, and Streams API that improve parallel data processing. Maven was used for managing the project build, and handling dependencies. The project was deployed using docker on the docker hub.
# Quick Start
### This app can be executed using any of these two major methods:
1. Execute using maven life cycle on the terminal as shown:
    - `$ mvn clean compile`

    -  `$ mvn package`

    - `$ java -cp target/grep-1.0-SNAPSHOT.jar ca.jrvs.apps.grep.JavaGrepImp {regex} {rootPath} {outFile}`
    - `java -cp target/grep-1.0-SNAPSHOT.jar ca.jrvs.apps.grep.JavaGrepImp {regex} {rootPath} {outFile}`

2. Execute the app using docker:
    - `docker run -rm -v host/path/to/scan:/data -v host/path/for/output/file:/out nkirukodu/grep "place pattern here" /data /out/grep.out.txt`

# Implementation
The grep app was implemented using Java Collection, and another Java class using Lambda and Streams API.
## Pseudocode
For a very successful software application, there is always good pseudocode to facilitate the build process: The grep app was implemented by using this pseudocode
```
matchedLines = []
for file in listFilesRecursively(rootDir)
  for line in readLines(file)
      if containsPattern(line)
        matchedLines.add(line)
writeToFile(matchedLines)
```
## Performance Issue
The first implementation of the grep app which uses the java collections may have performance issues in terms of memory when dealing with large-size text files. Therefore to build a higher-performance app, Stream API was used to resolve this problem, since it allows lazy and efficient processing of files as well as properly managing the amount large-sized text-files.
# Test
The grep app was tested locally using sample text files to ensure that the app produces the expected results. In addition to this, incorrect inputs were passed through the app to ensure that it can properly handle exceptions.
# Deployment
A docker image was created from uber jar file and deployed to the docker hub.
- Create the Dockerfile
```
FROM openjdk:8-alpine
COPY target/grep*.jar /usr/local/app/grep/lib/grep.jar
ENTRYPOINT ["java","-jar","/usr/local/app/grep/lib/grep.jar"]
```
Here, the base image is the `openjdk:8-alpine` which has the Alpine Linux Distribution on `openjdk8`. The second line specifies the files to be copied to the image, while the `entry point` specifies where the image will be started from the container.
- Build the docker image

```
docker build -t ${docker_user}/grep .
```
- verify the image
```
docker run --rm \
-v `pwd`/data:/data -v `pwd`/log:/log \
${docker_user}/grep .*Romeo.*Juliet.* /data /log/grep.out
```
- push the image to Docker Hub

```
docker push ${docker_user}/grep
```

where `{docker_user}` = my username
# Improvement
Although the main objectives was achieved, but there are some functionalities that would be added to the app to make much more efficient:
1. Build more methods to ignore cases on the text file
2. The app can be extended to search beyond just the text file but also through the directory for any possible match