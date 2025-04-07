package home

import (
	"gno.land/p/moul/txlink"
	"gno.land/p/moul/md"
	"gno.land/p/moonia/utils"
	"std"
	"strconv"
)

// TODO: GRC-20
// TODO: token stream

// TODO: move out to p/dao
type Proposal struct {
	Title       string
	Description string
	Creator     std.Address
	YesVotes    int
	NoVotes     int
	Voters      map[std.Address]bool
	Active      bool
}

type DAO struct {
	Whitelist map[std.Address]bool
	Proposals []Proposal
}

var myDAO DAO

func init() {
	myDAO = DAO{
		Whitelist: make(map[std.Address]bool),
		Proposals: []Proposal{},
	}
}

// TODO: move method to r/dao
func JoinWhitelist() string {
	caller := utils.GetCaller()
	if myDAO.Whitelist[caller] {
		return "You're already in the whitelist."
	}
	myDAO.Whitelist[caller] = true
	return "Successfully joined the whitelist!"
}

// TODO: move method to r/dao
func ShowWhitelist() string {
	out := "## Whitelist Members ✅\n\n"
	if len(myDAO.Whitelist) == 0 {
		return out + "_Whitelist is empty._\n"
	}
	for addr := range myDAO.Whitelist {
		out += "- " + addr.String() + "\n"
	}
	return out
}

// TODO: move method to r/dao
func CreateProposal(title string, description string) string {
	caller := utils.GetCaller()
	if !myDAO.Whitelist[caller] {
		return "Only whitelisted members can create proposals."
	}
	p := Proposal{
		Title:       title,
		Description: description,
		Creator:     caller,
		YesVotes:    0,
		NoVotes:     0,
		Voters:      make(map[std.Address]bool),
		Active:      true,
	}
	myDAO.Proposals = append(myDAO.Proposals, p)
	return "📢 Proposal created: " + title
}

// TODO: move method to r/dao
func Vote(indexStr string, voteYesStr string) string {
	index, err := strconv.Atoi(indexStr)
	if err != nil {
		return "Invalid proposal index format."
	}

	voteYes := voteYesStr == "true"
	caller := utils.GetCaller()

	if !myDAO.Whitelist[caller] {
		return "Only whitelisted members can vote."
	}
	if index < 0 || index >= len(myDAO.Proposals) {
		return "Invalid proposal index."
	}
	p := &myDAO.Proposals[index]
	if !p.Active {
		return "Voting is closed for this proposal."
	}
	if p.Voters[caller] {
		return "You have already voted."
	}

	p.Voters[caller] = true
	if voteYes {
		p.YesVotes++
	} else {
		p.NoVotes++
	}
	return "Vote recorded!"
}

// default test
// or
// gnokey maketx call -pkgpath "gno.land/r/moonia/home" -func "CreateProposal" -args "TITLE" -args "DESCRIPTION" -gas-fee 1000000ugnot -gas-wanted 5000000 -broadcast -chainid "dev" -remote "tcp://127.0.0.1:26657" ADDRESSHERE
func CreateProposalTest() string {
	return CreateProposal("Survey", "Would you like to visit guatemala?")
}

func ShowProposals() string {
	out := "## Proposals 📋\n\n"
	if len(myDAO.Proposals) == 0 {
		return out + "_No proposals yet._\n"
	}
	for i, p := range myDAO.Proposals {
		status := "Active 🟢"
		if !p.Active {
			status = "Closed 🔴"
		}
		out += "**[" + strconv.Itoa(i) + "]** " + p.Title + " :\n" + p.Description + "\n" + status + "\n\n"
		out += "by _" + p.Creator.String() + "_" + "\n"
		out += "  - ✅ " + strconv.Itoa(p.YesVotes) + " | ❌ " + strconv.Itoa(p.NoVotes) + " — "
		out += md.Link("Vote Yes", txlink.Call("Vote", strconv.Itoa(i), "true")) + " | "
		out += md.Link("Vote No", txlink.Call("Vote", strconv.Itoa(i), "false")) + "\n\n"
	}
	return out
}

func renderDAO() string {
	out := "# Moonia's DAO\n\n"
	out += "## Actions:\n\n"
	out += "- " + md.Link("Join Whitelist", txlink.Call("JoinWhitelist")) + "\n"
	out += "- " + md.Link("Create Sample Proposal", txlink.Call("CreateProposalTest")) + "\n"
	out += ShowWhitelist() + "\n"
	out += ShowProposals()
	return out
}

func Render(path string) string {
	return renderDAO()
}
