# InstaCap API Testing Guide

This guide helps you test the InstaCap API using both the Node.js test script and Postman.

## Testing with Node.js Script

The `test-api.js` script in this directory can be used to automatically test all API endpoints.

### Prerequisites
- Node.js installed
- Axios package installed (`npm install axios`)

### Running the Test Script
```bash
# From the Backend directory
node test-api.js
```

This will run tests for all endpoints and display the results in the console.

## Testing with Postman

The Postman collection and environment files are located in the `postman` directory.

### Setup Instructions

1. **Import the Collection and Environment**
   - Open Postman
   - Click "Import" in the top left corner
   - Select both `InstaCap_API_Collection.json` and `InstaCap_API_Environment.json` files
   - Click "Import"

2. **Set the Environment**
   - In the top right corner of Postman, click the environment dropdown
   - Select "InstaCap API Environment"

### Testing Workflow

#### 1. Basic Endpoints
Start with testing the non-authenticated endpoints:
- Root Endpoint (`/`)
- Health Check (`/health`)
- API Test (`/api/test`)

#### 2. Authentication Flow
1. **Register a New User**
   - Use the "Register" request in the Authentication folder
   - Modify the email, password, and displayName as needed
   - Send the request

2. **Login**
   - Use the "Login" request with the same credentials
   - The auth token will be automatically saved to the environment

3. **Get Current User**
   - Run this request to check if the authentication works correctly

#### 3. Caption Generation
1. **Generate Caption**
   - Make sure you're authenticated (completed login step)
   - Use the "Generate Caption" request to test caption generation
   - Check the response for the generated caption and caption ID

2. **Get User Captions**
   - Test retrieving all captions for the current user

3. **Delete Caption**
   - Set the `captionId` variable in the environment to the ID of a caption
   - Run the "Delete Caption" request

## Common Issues and Solutions

### 401 Unauthorized
- Make sure you've logged in and have a valid auth token
- Check if the token is correctly set in the environment

### 404 Not Found
- Verify the endpoint URL is correct
- Check if the API server is running

### 500 Internal Server Error
- Check the server logs
- Ensure all required environment variables are set on the server

## API Base URL

The current API base URL is set to:
```
https://instacap.onrender.com
```

If you need to change it, update the `baseUrl` variable in the Postman environment.
