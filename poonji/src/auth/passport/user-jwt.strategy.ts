import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import CONFIG from 'src/utils/config';

@Injectable()
export class UserJwtStrategy extends PassportStrategy(Strategy, 'user-jwt') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: CONFIG.JWT_SECRET,
    });
  }

  async validate(user: any) {
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      upi_id: user.upi_id,
      user_id: user.user_id,
      isKYCVerified: user.isKYCVerified,
      credibility_score: user.credibility_score
    };
  }
}
