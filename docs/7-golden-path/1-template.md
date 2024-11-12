## Use the template

1. Use the GitHub UI to create a new repository from the template repository [`template-node`](https://github.com/mediona/template-node). Alternatively, you can sync your repository with the template repository by following the instructions [here](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template).

The template provides you with a Dockerfile, a GitHub Actions workflow, and a `README.md` file. The workflow builds a Docker image and pushes it to the GitHub Container Registry. The Docker image is tagged with the commit SHA and the `latest` tag. Also it packages the application code and create a Helm chart.

2. Adapt the template repository to your needs:

    - Replace `$NODE_APP_NAME` with the name of your application.
    - Update the `README.md` file with your project's information.
    - Push the changes to your repository.
    - Check the workflow runs successfully.

3. Push your code to GitHub and check all the workflows run successfully.

4. Merge your changes to the `main` branch and the container image and the Helm chart will be built and pushed to the GitHub registry.
