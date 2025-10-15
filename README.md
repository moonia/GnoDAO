# DAO on Gno.land

GnoDAO is an on-chain DAO app built on [gno.land](https://gno.land/). This project serves as an initial experiment with [Gno](https://github.com/gnolang/gno), introducing a simple and interactive decentralized governance system.
## 📖 Description

It allows members to:

- Define a **single administrator**.
- **Join or leave** the DAO (via a dynamic whitelist).
- **Create, edit, and close proposals**.
- **Vote** (yes/no) on active proposals.
- View **DAO statistics** in real time.

## 🚀 Key Features 

- **Admin Management**:
  - The `SetAdmin()` function allows a one-time admin setup.

- **Whitelist System**:
  - Users can join with `JoinDAO()` and leave with `LeaveDAO()`.
  - Whitelist members are displayed via `ShowWhitelist()`.

- **Proposal System**:
  - Create new proposals with `CreateProposal(title, description)`.
  - Only the creator can close or edit a proposal.
  - View all proposals (active/closed) via `ShowProposals()`.

- **Voting Mechanism**:
  - Whitelisted members can vote once per active proposal (yes/no).
  - Voting is disabled once the proposal is closed.

- **Statistics**:
  - Total number of proposals.
  - Number of active proposals.
  - Number of whitelist members.

## 📸 Screenshots 

<img width="300" height="485" alt="434240077-ab49cb23-14db-4f5b-b49b-8c8ba5a51592" src="https://github.com/user-attachments/assets/5e8a4b70-640d-4430-b0c0-aeb6681fbcf9" />
<img width="300" height="485" alt="434240182-cac757e0-c7f2-4b16-acaa-fab660f96822" src="https://github.com/user-attachments/assets/b9d24c3a-c08a-433b-bbad-2bc449139d07" />
