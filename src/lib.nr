mod constants;
mod frog;

use dep::semaphore::{calculate_nullifier_hash, SemaphoreIdentity};
use frog::Frog;

pub fn assert_frog_ownership(
    frog: Frog,
    frog_signer_pubkey_A_x: Field,
    frog_signer_pubkey_A_y: Field,
    frog_signature_s: Field,
    frog_signature_r8_x: Field,
    frog_signature_r8_y: Field,
    semaphore_identity: SemaphoreIdentity,
) {
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
    assert_eq(
        frog.owner_semaphore_id,
        semaphore_identity.commitment(),
        "semaphore identity does not match frog owner",
    );
}

#[test]
fn prove_frog_ownership() {
    // This test proves my ownership of a real frog from ZuPass on a burner semaphore identity.
    // This can be verified as I use the same public key as used by ZuPass at Devconnect, proving this frog to be authentic.

    let my_frog = Frog {
        id: 10,
        biome: constants::biome::SWAMP,
        rarity: constants::rarity::COMMON,
        temperament: constants::temperament::HRNY,
        jump: 3,
        speed: 3,
        intelligence: 3,
        beauty: 5,
        timestamp_signed: 1700247745620,
        owner_semaphore_id:
            10748096169585012891334706690982223299749822368867987828636352599303890592652,
        reserved_field1: 0,
        reserved_field2: 0,
        reserved_field3: 0,
    };

    let frog_signer_pubkey_A_x = 0x0f183dcba06341a4549d78c3f8ca0060a9d6aca795103cb6957d1e2973b5fdeb;
    let frog_signer_pubkey_A_y = 0x2a2eb70efeebb5facca2f3668ca5642513be542bab285055ccdcbc18cc125fd5;
    let frog_signature_r8_x =
        15613161476408051753994748029148156840563446124567582295534699602200871371520;
    let frog_signature_r8_y =
        329644455938015313062655421435012831670569297122442465540842329787009122068;
    let frog_signature_s =
        1180875539005529179372618369618962788076726154735716651622589590606983335434;

    // Burner identity.
    let my_identity = SemaphoreIdentity {
        nullifier: 0xaeb46773a509e707a80a9eb3fa85cf8ba426192086699a9d977e2d6cd317b8,
        trapdoor: 0x8e4186d096420554fca8b2296b7996dc035b0a5f24bd607013a01ac4ae14e1,
    };

    assert_frog_ownership(
        my_frog,
        frog_signer_pubkey_A_x,
        frog_signer_pubkey_A_y,
        frog_signature_s,
        frog_signature_r8_x,
        frog_signature_r8_y,
        my_identity,
    );
}
