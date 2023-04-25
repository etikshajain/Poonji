import { CacheModule, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import CONFIG from './utils/config';
import { AuthModule } from './auth/auth.module';
import { P2pController } from './p2p/p2p.controller';
import { P2pService } from './p2p/p2p.service';
import { P2pModule } from './p2p/p2p.module';

@Module({
  imports: [
    MongooseModule.forRoot(CONFIG.MONGODB_STRING),
    AuthModule,
    P2pModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
  ],
})
export class AppModule {}