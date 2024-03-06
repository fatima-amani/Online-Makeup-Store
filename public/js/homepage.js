// Function to retrieve and store the token
function getTokenAndStore() {
    // Retrieve the token from the page (e.g., from a hidden input field)
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    // Store the token securely in local storage
    localStorage.setItem('accessToken', token);
}

// Function to send authenticated requests
async function sendAuthenticatedRequest(url, method, data) {
    try {
        const accessToken = localStorage.getItem('accessToken');

        // Add the token to the Authorization header
        const headers = {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        };

        // Make the HTTP request
        const response = await fetch(url, {
            method: method,
            headers: headers,
            body: JSON.stringify(data)
        });

        // Handle the response
        if (response.ok) {
            const responseData = await response.json();
            console.log('Response:', responseData);
        } else {
            console.error('Error:', response.statusText);
        }
    } catch (error) {
        console.error('Error sending request:', error);
    }
}
