# Add my Node.js application to the platform

## Create a repository from the template or sync with the template repository

1. Use the GitHub UI to create a new repository from the template repository [`template-node`](https://github.com/mediona/template-node). Alternatively, you can sync your repository with the template repository by following the instructions [here](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template).

The template provides you with a Dockerfile, a GitHub Actions workflow, and a `README.md` file. The workflow builds a Docker image and pushes it to the GitHub Container Registry. The Docker image is tagged with the commit SHA and the `latest` tag. Also it packages the application code and create a Helm chart.

2. Adapt the template repository to your needs:

    - Replace `$NODE_APP_NAME` with the name of your application.
    - Update the `README.md` file with your project's information.
    - Push the changes to your repository.
    - Check the workflow runs successfully.

3. Add your application code to the configuration repository:

    - Clone or pull the [configuration repository](https://github.com/mediona/build-your-own-platform) to your local machine.
    - Add your application code to the `apps` directory.
    - Commit and push the changes to the configuration repository.
    - Wait for approval if it goes to production, otherwise a team member can approve the changes.
    - Merge and check the application is deployed successfully.

For next updates all you need to do is to update the HelmRelease resource in the configuration repository with the new image tag. A workflow can be configured to do it for every release you do.
