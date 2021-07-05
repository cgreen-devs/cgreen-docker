# cgreen-docker
Dockerfile for cgreen

This creates a docker image that has

- Cgreen installed
- a quick and dirty .deb file created

This was created to ensure there was a Cgreen package available to be
installed on CI servers, such as Travis. It is currently based on
Ubuntu:bionic (because that's the most modern Travis supports) and
Cgreen 1.4.0 (latest release at the time of writing).

You can easily create a .deb file for another Cgreen release by
changing the ARG in the Dockerfile.
