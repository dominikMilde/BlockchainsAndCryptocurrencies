package hr.fer.rgkk.transactions;

import org.bitcoinj.core.ECKey;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.crypto.TransactionSignature;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

public class PayToPubKeyHash extends ScriptTransaction {
    private final ECKey key;
    public PayToPubKeyHash(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
        key = getWallet().freshReceiveKey();
    }

    @Override
    public Script createLockingScript() {
        return new ScriptBuilder()     // Create new ScriptBuilder object that builds locking script
                .data(key.getPubKey()) // Add public key to the locking script
                .op(OP_DUP)
                .op(OP_HASH160)
                .data(key.getPubKeyHash())
                .op(OP_EQUALVERIFY)
                .op(OP_CHECKSIG)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedTransaction) {
        TransactionSignature txSig = sign(unsignedTransaction, key); // Create key signature
        return new ScriptBuilder()                                   // Create new ScriptBuilder
                .data(txSig.encodeToBitcoin())                       // Add key signature to unlocking script
                .build();
    }
}
