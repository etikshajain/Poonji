import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from 'src/schemas/user.schema';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import CONFIG from 'src/utils/config';
import { generate_RDVID, generateOTP, generatePassword } from 'src/utils/rdv';
import { sendRDV, sendOTP, sendPass } from 'src/utils/mail';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    private jwtService: JwtService,
  ) {}

  async createUser(
    name: string,
    email: string,
    phone: string,
    password: string,
    upi_id: string
  ) {
    email = email.trim().toLowerCase();
    const u = await this.userModel.findOne({ email: email });
    if (u) return 1;

    const hash = await bcrypt.hash(password, Number(CONFIG.BCRYPT_ROUNDS));
    const user_id = generate_RDVID(name);
    // TODO: any validation on frontend?
    const user = new this.userModel({
      name: name,
      email: email,
      phone: phone,
      password_hash: hash,
      upi_id: upi_id,
      user_id: user_id,
      isKYCVerified: false,
      credibility_score: 0
    });
    return user.save();
  }

  async validateEmailUser(email: string, password: string): Promise<any> {
    const user = await this.userModel.findOne({ email: email });
    if (user && (await bcrypt.compare(password, user.password_hash))) {
      const payload = {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        upi_id: user.upi_id,
        user_id: user.user_id,
        isKYCVerified: user.isKYCVerified,
        credibility_score: user.credibility_score
      };
      return payload;
    }
    return null;
  }

  async loginUser(user) {
    const payload = {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      college: user.college,
      upi_id: user.upi_id,
      user_id: user.user_id,
      isKYCVerified: user.isKYCVerified,
      credibility_score: user.credibility_score
    };
    return { access_token: this.jwtService.sign(payload) };
  }

  async userForgotPassword(email: string) {
    const u = await this.userModel.findOne({ email: email });
    if (!u) {
      return 0;
    } else {
      const pass = generatePassword(String(new Date().valueOf()), email);
      u.password_hash = await bcrypt.hash(pass, CONFIG.BCRYPT_ROUNDS);
      await u.save();
      await sendPass(email, u.name, pass);
      return 1;
    }
  }
}
