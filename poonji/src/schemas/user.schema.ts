import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema()
export class User {
  @Prop({ required: true })
  name: string;
  @Prop({ required: true, unique: false })
  email: string;
  @Prop({ required: true, unique: false })
  user_id: string;

  @Prop({ required: true })
  password_hash: string;

  @Prop({ required: true, default: false })
  isKYCVerified: boolean;

  @Prop({ required: true, unique: false })
  upi_id: string;
  @Prop({ required: true, unique: false })
  credibility_score: Number;
}

export type UserDocument = User & Document;
export const UserSchema = SchemaFactory.createForClass(User);