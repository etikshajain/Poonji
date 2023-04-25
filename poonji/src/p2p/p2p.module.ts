import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Loan, LoanSchema } from 'src/schemas/loan.schema';
import { User, UserSchema } from 'src/schemas/user.schema';
import { P2pController } from './p2p.controller';
import { P2pService } from './p2p.service';
import { UserLocalStrategy } from 'src/auth/passport/user-local.strategy';
import { AuthModule } from 'src/auth/auth.module';

@Module({
    imports: [
      MongooseModule.forFeature([
        { name: User.name, schema: UserSchema },
        { name: Loan.name, schema: LoanSchema }
      ]),
      AuthModule,
    ],
    controllers: [P2pController],
    providers: [P2pService, UserLocalStrategy],
    exports:[
      P2pService,
    ]
  })
export class P2pModule {}
