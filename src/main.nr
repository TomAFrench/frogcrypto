mod constants;
mod frog;

use frog::Frog;
use dep::semaphore::{SemaphoreIdentity, calculate_nullifier_hash};

fn main(
    frog: Frog,
    frog_signer_pubkey_A_x: Field,
    frog_signer_pubkey_A_y: Field,
    frog_signature_s: Field,
    frog_signature_r8_x: Field,
    frog_signature_r8_y: Field,
    semaphore_identity: SemaphoreIdentity,
    external_nullifier: pub Field,
    // watermark is included to allow tying proof to a particular challenge but otherwise unused.
    watermark: pub Field,
) -> pub Field {
    // Check that input is a well-formed frog.
    let is_valid_frog = frog.is_valid(
        frog_signer_pubkey_A_x,
        frog_signer_pubkey_A_y,
        frog_signature_s,
        frog_signature_r8_x,
        frog_signature_r8_y,
    );
    assert(is_valid_frog, "Invalid frog");

    // Verify semaphore private identity matches the frog owner semaphore identity commitment.
    assert_eq(frog.owner_semaphore_id, semaphore_identity.commitment(), "semaphore identity does not match frog owner");

    calculate_nullifier_hash(external_nullifier, semaphore_identity.nullifier)
}
