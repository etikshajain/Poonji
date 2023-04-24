import { randomUUID } from 'crypto';
import { createHash } from 'crypto';
import CONFIG from './config';

const generate_RDVID = (name: string) => {
  const n = name.replace(' ', '').toUpperCase().padEnd(4, 'X').substring(0, 4);
  const u = randomUUID().split('-')[0].toUpperCase();
  return `${n}${u}`;
};

const generatePassword = (id: string, address: string) => {
  // address is email or phone
  const str = `${id}_${address}_${CONFIG.OTP_SALT}`;
  const hash = createHash('sha256').update(str).digest('hex');
  return hash.substring(0, 6);
};

const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
  // return randomUUID().split('-')[0].toUpperCase();
};

export { generate_RDVID, generatePassword, generateOTP };
