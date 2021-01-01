module docker

import builder

pub enum DockerContainerStatus {
	up
	down
	restarting
	paused
	dead
	created
}

// need to fill in what is relevant
struct DockerContainer {
	id          	string
	name        	string
	hostname    	string
	created    		string
	ssh_enabled 	bool // if yes make sure ssh is enabled to the container
	info        	DockerContainerInfo
	ports       	[]string
	forwarded_ports	[]string
	mounted_volumes	[]DockerContainerVolume
	engine			DockerEngine

pub mut:
	node        builder.Node
	image       DockerImage
	status      DockerContainerStatus
}

struct DockerContainerInfo {
	ipaddr builder.IPAddress
}

struct DockerContainerVolume{
	src 	string
	dest	string
}

pub struct DockerContainerCreateArgs{
	name        	string
	hostname    	string
	forwarded_ports	[]string // ["80:9000/tcp", "1000, 10000/udp"]
	mounted_volumes	[]string // ["/root:/root", ]
	image_repo      string
}


// create/start container (first need to get a dockercontainer before we can start)
pub fn (mut container DockerContainer) start() ?string {
	c := container.node.executor.exec('docker start $container.id') or {panic(err)}
	container.status = DockerContainerStatus.up
	return c
}

// delete docker container
pub fn (mut container DockerContainer) halt() ?string {
	c := container.node.executor.exec('docker stop $container.id') or {panic(err)}
	container.status = DockerContainerStatus.down
	return c
}

// delete docker container
pub fn (mut container DockerContainer) delete(force bool) ?string {
	if force {
		return container.node.executor.exec('docker rm -f $container.id')
	}
	return container.node.executor.exec('docker rm $container.id')
}

// save the docker container to image
pub fn (mut container DockerContainer) save2image(image_id string) ?string {
	return container.node.executor.exec('docker commit $container.id $image_id')
}

// export docker to tgz
pub fn (mut container DockerContainer) export(path string) ?string {
	return container.node.executor.exec('docker export $container.id > $path')
}

// import a container into an image, run docker container with it
// if DockerContainerCreateArgs contains a name, container will be created and restarted
pub fn (mut container DockerContainer) load(path string, image_repo_url string, args DockerContainerCreateArgs) ?string {
	return container.node.executor.exec('docker import  $path $image_repo_url')
}

// open ssh shell to the cobtainer
pub fn (mut container DockerContainer) ssh_shell() ? {
}

// return the builder.node class which allows to remove executed, ...
pub fn (mut container DockerContainer) node_get() ?builder.Node {
	return container.node
}
