require('dotenv').config();

const CONFIG = {
  PORT: process.env.PORT || 8080,
  MONGODB_STRING: process.env.MONGODB_STRING,
  JWT_SECRET: process.env.JWT_SECRET,
  BCRYPT_ROUNDS: Number(process.env.BCRYPT_ROUNDS),
};

export default CONFIG;