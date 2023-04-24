import { Body, Controller, Get, Post, Query, Req, UseGuards } from '@nestjs/common';
import { UserAuthGuard } from 'src/auth/passport/user-auth.guard';
import { P2pService } from './p2p.service';

@Controller('p2p')
@UseGuards(UserAuthGuard)
export class P2pController {
    constructor(private readonly p2pService: P2pService) {}

    @Get('getLoans')
    async getLoans(@Query() args) {
        const { status, borrower, lender } = args; // only one will be non-null
        return this.p2pService.getLoans(status, borrower, lender);
    }

    @Post('requestLoan')
    async requestLoan(@Body() body, @Req() req: Express.Request) {
        const {amount } = body;
        const id = req['user'].id;
        return this.p2pService.requestLoan(id, amount);
    }

    @Post('giveLoan')
    async giveLoan(@Body() body, @Req() req: Express.Request) {
        const { loan_id } = body;
        const id = req['user'].id;
        return this.p2pService.giveLoan(id, loan_id);
        // todo: take amount receipt and also update credit score
    }

    @Post('claimLoan')
    async claimLoan(@Body() body, @Req() req: Express.Request) {
        const { loan_id } = body;
        const id = req['user'].id;
        return this.p2pService.giveLoan(id, loan_id);
    }
}
