# docker-rstats

[Kaggle Notebooks](https://www.kaggle.com/notebooks) allow users to run scripts against our competitions and datasets without having to download data or set up their environment. 

Our R Docker images are stored on Google Container Registry at:

* CPU-only: [gcr.io/kaggle-images/rstats](https://gcr.io/kaggle-images/rstats)
* GPU: [gcr.io/kaggle-gpu-images/rstats](https://gcr.io/kaggle-gpu-images/rstats)

Here's [an example](https://www.kaggle.com/benhamner/bike-sharing-demand/bike-rentals-by-time-and-temperature):

![example script](http://i.imgur.com/Hk703P7.png)

This is the Dockerfile (etc.) used for building the image that runs R scripts on Kaggle. [Here's](https://registry.hub.docker.com/u/kaggle/rstats/) the Docker image on Dockerhub.

## Getting started

To get started with this image, read our [guide](http://blog.kaggle.com/2016/02/05/how-to-get-started-with-data-science-in-containers/) to using it yourself, or browse [Kaggle Notebooks](https://www.kaggle.com/notebooks) for ideas.

## Requesting new features

**We welcome pull requests** if there are any packages you'd like to add!

We can merge your request quickly if you check that it builds correctly. Here's how to do that.

### New R libraries

If you want a library that's, say, on GitHub but not yet on CRAN, then you can add it to [`package_installs.R`](https://github.com/Kaggle/docker-rstats/blob/master/package_installs.R). To check that it will work, you can follow this example, which shows how to add a library called `coolstuff` that's available from GitHub user `nerdcha`.

```bash
me@my-computer:/home$ docker run --rm -it kaggle/rstats
R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
[...etc...]
> library(devtools)
> install_github("nerdcha/coolstuff")
Downloading GitHub repo nerdcha/coolstuff@master
[...etc...]
** testing if installed package can be loaded
* DONE (coolstuff)
> library(coolstuff)
>
```

Everything worked, so we can add the line `install_github("nerdcha/coolstuff")` to `package_installs.R` and submit the pull request.

### New libraries with complex dependencies

Some libraries will need extra system support to work. Installing them follows a pretty similar pattern; just try whatever prerequisites the package maintainer says are needed for a Linux system. For example, if the `coolstuff` package says to run `apt-get install libcool-dev` first, then you can test it in the following way.

```bash
me@my-computer:/home$ docker run --rm -it kaggle/rstats /bin/bash
root@2dd4317c8799:/# apt-get update
Ign:1 http://ftp.de.debian.org/debian jessie InRelease
[...]
root@2dd4317c8799:/# apt-get install libcool-dev
Reading package lists... Done
[...]
root@2dd4317c8799:/# R
R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
[...]
> library(devtools)
> install_github("nerdcha/coolstuff")
Downloading GitHub repo nerdcha/coolstuff@master
[...]
** testing if installed package can be loaded
* DONE (coolstuff)
> library(coolstuff)
>
```

If that's all working as expected, then you can add `apt-get install libcool-dev` to the end of the [`Dockerfile`](https://github.com/Kaggle/docker-rstats/blob/master/Dockerfile), and `install_github("nerdcha/coolstuff")` to `package_installs.R`.

