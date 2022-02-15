package hr.fer.rgkk.transactions;

import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

public class LogicalEquivalenceTransaction extends ScriptTransaction {

    public LogicalEquivalenceTransaction(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
    }

    @Override
    public Script createLockingScript() {
        int x = 0;
        int y = 0;

        return new ScriptBuilder()     // Create new ScriptBuilder object that builds locking script
                .smallNum(x)
                .smallNum(1)
                .op(OP_LESSTHANOREQUAL)
                .smallNum(x)
                .smallNum(0)
                .op(OP_GREATERTHANOREQUAL)
                .smallNum(y)
                .smallNum(1)
                .op(OP_LESSTHANOREQUAL)
                .smallNum(y)
                .smallNum(0)
                .op(OP_GREATERTHANOREQUAL)
                .smallNum(x)
                .smallNum(y)
                .op(OP_EQUALVERIFY)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedScript) {
        long x = 1;
        long y = 1;
        return new ScriptBuilder()
                .number(x)
                .number(y)
                .build();
    }
}
