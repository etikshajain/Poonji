import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Types } from 'mongoose';
import { User } from './user.schema';

@Schema()
export class Loan {
  @Prop({ required: true, type: Types.ObjectId, ref: 'User' })
  borrower:User;
  @Prop({ required: true, type: Types.ObjectId, ref: 'User' })
  lender:User;

  @Prop({required: true, unique: false  })
  start_time:Date;
  @Prop({required: true, unique: false  })
  end_time:Date;

  @Prop({required: true, unique: false  })
  amount:Number;

  @Prop({required: true, unique: false  })
  status:string;
}

export type LoanDocument = Loan & Document;
export const LoanSchema = SchemaFactory.createForClass(Loan);