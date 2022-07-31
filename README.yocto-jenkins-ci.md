Yocto Jenkins CI Template
=========================

The goal of this project is to provide a fully scripted template to set up a Yocto CI Server
based on Jenkins.

The work is based on [modern-jenkins-setup](https://github.com/langchr86/modern-jenkins-setup)
by Christan Lang.


Overview
--------

This project can be used as template for a completely scripted
and therefore easy maintainable Jenkins instance for Yocto CI/CD.

Supported Linux Distributions:
* Ubuntu 22.04
* Debian Bullseye

The main technologies used are:

* Ansible for automated setup
* Containers: Docker & docker-compose
* Sysbox Container Runtime (CE) for rootless containers that support Docker-in-Docker:
  [Sysbox](https://github.com/nestybox/sysbox)
* Reverse-proxy & file hosting: [Caddy2](https://caddyserver.com/v2)
* CI/CD: [Jenkins](https://www.jenkins.io/)
* Running Jenkins in Containers: [Jenkins in Docker](https://www.jenkins.io/doc/book/installing/docker/)
  based on: [Official Jenkins Docker image](https://github.com/jenkinsci/docker/blob/master/README.md)
* Scripted Jenkins Config: [Configuration as Code](https://plugins.jenkins.io/configuration-as-code/)
* Configurable jobs: [JobDSL](https://plugins.jenkins.io/job-dsl/)
* Bitbake hash equivalence servers: [Hash Equivalence](https://docs.yoctoproject.org/4.0.2/overview-manual/concepts.html?highlight=hash+equivalence#hash-equivalence)



Quick start
-----------

This example project can be run inside a virtual machine.
The used tools are:

* VM Hypervisor: Virtualbox (Windows), KVM/QEMU (Linux)
* VM management: Vagrant
* Host Provisioning: Ansible

To run the VM a working installation of Virtualbox and Vagrant is required.
The VM can be created and started by running:

Windows:
~~~~~~
vagrant up virtualbox-ubuntu2204

or

vagrant up virtualbox-bullseye
~~~~~~

Linux:
~~~~~~
vagrant up libvirt-ubuntu2204

or

vagrant up libvirt-bullseye
~~~~~~

The VM creation and provisioning will take a while.
Even after the VM runs and provisioning has finished it may need some time until the docker images
have been created and the corresponding containers started.
The Jenkins and artifacts services can be accessed at:

* [jenkins.localhost](https://jenkins.localhost/)
* [artifacts.localhost](https://artifacts.localhost/)

Insecure https certificate is expected since the setup os running on the local machine.



Working with the VM
-------------------

To access the VM we can directly use the Virtualbox GUI, `vagrant ssh <virtualbox-ubuntu2004|virtualbox-bullseye|libvirt-ubuntu2204|libvirt-bullseye>` or any other SSH agent like `PuTTY`.
The user and password is `vagrant`.

After connecting we can observe the logs of the Jenkins docker-compose run:

~~~~~~
sudo journalctl -fu jenkins
~~~~~~

The main file for the whole setup is the [`docker-compose.yml`] file.
file located in `/etc/docker-compose/jenkins/docker-compose.yml`.
All other relevant files (e.g. the `Dockerfile`) are located under `/etc/jenkins/`.

If needed we can manipulate the deployed files by hand and restart the service:

~~~~~~
sudo systemctl restart jenkins
~~~~~~

This will start all containers defined in the [`docker-compose.yml`] file.



Debugging
---------

The first run of the containers need some time because of the download and build of the container images.
If the container build does fail or never finish the whole process can be started manually for easier debugging.
First stop the systemd service:

~~~~~~
sudo systemctl stop jenkins
~~~~~~

Then change to `/etc/docker-compose/jenkins` and start the process by hand:

~~~~~~
docker-compose up --build
~~~~~~



Update Jenkins and plugins
--------------------------

All plugins and corresponding versions are provided in the [Base Jenkins plugins] .txt file.
Additional plugins .txt files can be added to this directory to be automatically installed
during the Docker image build.
The easiest way to update to the newest versions is to first update all plugins.
To do so just open the Jenkins web-UI and go to the [plugin manager](https://jenkins.localhost/pluginManager/) page.
Here we can see the newest version of each plugin.
Update the plugin version in the plugin .txt files for all available compatible updates.
Sometimes the name showed in the GUI do not directly match the name in the [Controller-Dockerfile].
The real raw name can be observed by clicking onto the link behind the GUI name.
After this we can restart the containers to see if everything is now up-to-date.
The easiest way to achieve this is to use Vagrant:

~~~~~~
vagrant provision <virtualbox-ubuntu2004|virtualbox-bullseye|libvirt-ubuntu2204|libvirt-bullseye>
~~~~~~

The related ansible role will update all files in the VM and restart the Docker containers.

After the plugins work with the newest versions we can update the Jenkins image itself.
The corresponding LTS base image can be found on [DockerHub](https://hub.docker.com/r/jenkins/jenkins/tags?page=1&name=lts-jdk11).
Now restart the containers again.

This described approach is useful to have fixed version numbers for an installation.
Jenkins itself provides various tools for automated updating.
See: [Preinstalling plugins](https://github.com/jenkinsci/docker/blob/master/README.md#preinstalling-plugins)


Documentation
-------------


### Jenkins Config as Code (JCasC)

* [configuration-as-code-plugin](https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/README.md)
* [Tutorial](https://opensource.com/article/20/4/jcasc-jenkins)
* [View the current live config](https://jenkins.localhost/configuration-as-code/viewExport)


### Job DSL

Always use the own instance as reference for the syntax.
This will only show features/plugins that are available on this instance.

* [JobDSL-API](https://jenkins.localhost/plugin/job-dsl/api-viewer/index.html#)


### Declarative Pipelines

This is still groovy syntax but a more abstracted DSL to define Jenkins Pipelines.

* [Declarative Pipeline](https://www.jenkins.io/doc/book/pipeline/syntax/)
* [Agents](https://www.jenkins.io/doc/book/pipeline/syntax/#agent)
* [Pipeline Steps](https://www.jenkins.io/doc/pipeline/steps/)


### Useful features and plugins

* [copyartifact](https://www.jenkins.io/doc/pipeline/steps/copyartifact/)
* [build-discarder](https://plugins.jenkins.io/build-discarder/)
* [docker-workflow](https://www.jenkins.io/doc/pipeline/steps/docker-workflow/)
* [Docker Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/)


### Nodes, Agents and Executors

* [Managing Nodes](https://www.jenkins.io/doc/book/managing/nodes/)
* [Base docker image for SSH connected agents](https://hub.docker.com/r/jenkins/ssh-agent)
* [Inbound Agent in Docker](https://github.com/jenkinsci/remoting/blob/master/docs/inbound-agent.md)
* [Instance Identity](https://jenkins.localhost/instance-identity/)


Relevant Files
--------------

* [Controller-Dockerfile]
* [`docker-compose.yml`]

[Controller-Dockerfile]: ansible/roles/jenkins-controller/files/dockerfiles/jenkins-controller/Dockerfile
[Base Jenkins plugins]: ansible/roles/jenkins-controller/files/jenkins_plugins/00-base.txt
[`docker-compose.yml`]: ansible/templates/example/docker-compose-service/docker-compose.yml
