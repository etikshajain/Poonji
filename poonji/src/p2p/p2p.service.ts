import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Loan, LoanDocument } from 'src/schemas/loan.schema';
import { User, UserDocument } from 'src/schemas/user.schema';

@Injectable()
export class P2pService {
    constructor(
        @InjectModel(User.name) private userModel: Model<UserDocument>,
        @InjectModel(Loan.name) private loanModel: Model<LoanDocument>,
      ) {}

    async requestLoan(user_id: string, amount: number) {
        const borrower = this.userModel.findById(user_id);
        if (!borrower) return -1;
        const loan = await this.loanModel.create({
            borrower: borrower,
            lender: null,
            amount: amount,
            status: 'requested'
        });
        return loan;
    }

    async giveLoan(user_id: string, loan_id: string) {
        const loan = await this.loanModel.findById(loan_id);
        const lender = await this.userModel.findById(user_id);

        if (!loan || !lender) return -1;

        loan.lender = lender;
        loan.start_time = new Date();
        loan.status = 'given';
        // todo: track payment
        return loan.save();
    }

    async claimLoan(loan_id) {
        const loan = await this.loanModel.findById(loan_id).populate('borrower lender');
        const upi = loan.borrower.upi_id;
        // todo: transfer money
        loan.status = 'claimed';
        return loan.save();
    }

    async getLoans(status: string|null, borrower: string|null, lender: string|null) {
        if (status) {
            return this.loanModel.find({status: status});
        }
        if (borrower) {
            return this.loanModel.find({borrower: borrower});
        }
        if (lender) {
            return this.loanModel.find({lender: lender});
        }
        return this.loanModel.find({});
    }
}
