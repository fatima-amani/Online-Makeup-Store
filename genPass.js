const bcrypt = require('bcrypt');

const generatePass = async (pass) => {
    try {
        const hashedPassword = await bcrypt.hash(pass, 10);
        console.log(hashedPassword);
    } catch (error) {
        console.error(error);
    }
}

// Example usage:
generatePass('vansh1234');
