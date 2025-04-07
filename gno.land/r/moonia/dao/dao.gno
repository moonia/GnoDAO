package dao

// import (
// 	"std"
// )

// TODO: move out to p/dao
// type IDAO interface {
// 	AddToWhitelist(user std.Address)
// 	CreateProposal(user std.Address, title string)
// 	Vote(user std.Address, proposalID int, vote bool)
// 	GetResults(proposalID int) (yes int, no int)
// }

// type Proposal struct {
// 	Title    string
// 	YesVotes int
// 	NoVotes  int
// 	Voters   map[std.Address]bool
// 	Active   bool
// }

// type DAO struct {
// 	Whitelist map[std.Address]bool
// 	Proposals []Proposal
// }