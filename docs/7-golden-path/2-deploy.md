## Deploy your application

1. Add your application code to the configuration repository:

    - Clone or pull the [configuration repository](https://github.com/mediona/build-your-own-platform) to your local machine.
    - Add your application code to the `apps` directory under the cluster directory you want to deploy your application to.
    - Commit and push the changes to the configuration repository.
    - Wait for approval if it goes to production, otherwise a team member can approve the changes.
    - Merge and check the application is deployed successfully.

For next updates all you need to do is to update the HelmRelease resource in the configuration repository in case the version is static defined or you change any configuration value.
