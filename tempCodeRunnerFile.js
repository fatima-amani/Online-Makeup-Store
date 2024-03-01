const hashedPassword = await bcrypt.hash(req.body.password, 10);
    console.log(req.body);