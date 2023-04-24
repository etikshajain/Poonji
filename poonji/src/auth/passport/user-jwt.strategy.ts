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

  async validate(payload: any) {
    return {
      id: payload.id,
      name: payload.name,
      email: payload.email,
      phone: payload.phone,
      college: payload.college,
      rdv_id: payload.rdv_id,
      referral_points: payload.referral_points,
      isIITD: payload.isIITD,
      isIITDFaculty: payload.isIITDFaculty,
      isIITDStaff: payload.isIITDStaff,
      isIITDVIP: payload.isIITDVIP,
      isInvitee: payload.isInvitee,
      isVerified: payload.isVerified,
    };
  }
}
