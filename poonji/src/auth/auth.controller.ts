import {
  BadRequestException,
  Body,
  Controller,
  ForbiddenException,
  Get,
  NotFoundException,
  Post,
  Query,
  Req,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { UserLocalGuard } from './passport/user-local.guard';
import * as express from 'express';
import { UserAuthGuard } from './passport/user-auth.guard';

// @UseGuards(ThrottlerGuard)
// @Throttle(15, 60)
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  // @Throttle(5, 60)
  @Post('createUser')
  async createUser(@Body() _body) {
    const { name, college, email, phone, password } = _body;
    const u = await this.authService.createUser(
      name,
      college,
      email,
      phone,
      password,
    );
    if (u === 1) {
      throw new BadRequestException('Email already exists');
    }
    return 'User sucessfully created';
  }

  // @Throttle(5, 60)
  @UseGuards(UserLocalGuard)
  @Post('loginUser')
  async loginUser(@Req() req: express.Request) {
    return this.authService.loginUser(req.user);
  }

  @UseGuards(UserAuthGuard)
  @Get('userProfile')
  async userProfile(@Req() req: express.Request) {
    return req.user;
  }

  // @Throttle(5, 60)
  @Get('userForgotPassword')
  async userForgotPassword(@Query() query) {
    const { email } = query;
    const result = await this.authService.userForgotPassword(email);
    if (result === 0) {
      throw new NotFoundException('Email not found, please create new account');
    } else {
      return 'Please check your email for the new password';
    }
  }

  // @Throttle(5, 300)
  @UseGuards(UserAuthGuard)
  @Get('requestEmailOTP')
  async requestEmailOTP(@Req() req: express.Request) {
    const user_id: string = req.user['id'];
    const r = await this.authService.requestEmailOTP(user_id);
    if (r === -1) throw new UnauthorizedException('User not found');
    if (r === -2) throw new BadRequestException('Already Verified');
    return r;
  }

  // @Throttle(5, 60)
  @UseGuards(UserAuthGuard)
  @Post('verifyEmailOTP')
  async verifyEmailOTP(@Req() req: express.Request) {
    const user_id: string = req.user['id'];
    const otp: string = req.body.otp;
    const r = await this.authService.verifyEmailOTP(user_id, otp);
    if (r === -1) throw new UnauthorizedException('User not found');
    if (r === -2) throw new BadRequestException('Already Verified');
    if (r === -3) throw new ForbiddenException('Wrong OTP');
    return r;
  }
}
