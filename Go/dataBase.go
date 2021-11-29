package main

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
)

type data struct {
	ano    int
	mes    int
	dia    int
	hora   int
	minuto int
}

type pessoa struct {
	aluno       string
	nome        string
	password    string
	mail        string
	socio       string
	telemovel   string
	cotas       bool
	visitas     []data
	visitasConf []data
	posts       []string
	kits        [][]bool
}

//RemoveIndex remove o um elemento do array
func RemoveIndex(s []string, index int) []string {
	ret := make([]string, 0)
	ret = append(ret, s[:index]...)
	return append(ret, s[index+1:]...)
}

//Pessoas é a lista de pssoas
var Pessoas []pessoa
var list = []string{"Logins", "Info", "Avisos", "Posts", "Kits", "Calendar"}

func printPerson(pp pessoa) {

	fmt.Print("Numero: " + pp.aluno)
	fmt.Print("\t")
	fmt.Print("Nome: " + pp.nome)
	fmt.Print("\t")
	fmt.Print("Password: " + pp.password)
	fmt.Print("\t")
	fmt.Print("Mail: " + pp.mail)
	fmt.Print("\n")
	fmt.Print("Socio: " + pp.socio)
	fmt.Print("\t")
	fmt.Print("Cotas: ")
	fmt.Print(pp.cotas)
	fmt.Print("\t")
	fmt.Print("Telemovel: " + pp.telemovel)
	fmt.Print("\n")
	fmt.Print("Visitas: ")
	fmt.Print(pp.visitas)
	fmt.Print("\n")
	fmt.Print("Visitas confirmadas: ")
	fmt.Print(pp.visitasConf)
	fmt.Print("\n")
	fmt.Print("Workshops: ")
	fmt.Print(pp.posts)
	fmt.Print("\n")
	fmt.Print("Kits: ")
	fmt.Print(pp.kits)
	fmt.Print("\n\n")

}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func removeDups(s string) string {
	var buf bytes.Buffer
	var last rune
	for i, r := range s {
		if r != last || i == 0 {
			buf.WriteRune(r)
			last = r
		}
	}
	return buf.String()
}

//ShowAllPeople mostra todas as pessoas (Logins)
func ShowAllPeople(ctx context.Context, client *firestore.Client, collect string) {

	iter := client.Collection(collect).Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		var id pessoa
		id.aluno = doc.Ref.ID
		id.nome = fmt.Sprintf("%v", doc.Data()["Username"])
		id.password = fmt.Sprintf("%v", doc.Data()["Password"])
		id.mail = fmt.Sprintf("%v", doc.Data()["mail"])
		id.socio = fmt.Sprintf("%v", doc.Data()["socio"])
		id.telemovel = fmt.Sprintf("%v", doc.Data()["telemovel"])
		if fmt.Sprintf("%v", doc.Data()["cotas"]) == "false" {
			id.cotas = false
		} else {
			id.cotas = true
		}
		x := fmt.Sprintf("%v", doc.Data()["visitas"])
		if x != "<nil>" {
			x = strings.Replace(x, "[", "", -1)
			x = strings.Replace(x, "]", "", -1)
			xx := strings.Split(x, " ")
			for i := 0; i < len(xx); i++ {
				xxx := strings.Split(xx[i], "_")
				var newData data

				newData.ano, _ = strconv.Atoi(xxx[0])
				newData.mes, _ = strconv.Atoi(xxx[1])
				newData.dia, _ = strconv.Atoi(xxx[2])
				newData.hora, _ = strconv.Atoi(xxx[3])
				newData.minuto, _ = strconv.Atoi(xxx[4])
				id.visitas = append(id.visitas, newData)
			}
		}
		x = fmt.Sprintf("%v", doc.Data()["visitasConf"])
		if x != "<nil>" {
			x = strings.Replace(x, "[", "", -1)
			x = strings.Replace(x, "]", "", -1)
			xx := strings.Split(x, " ")
			for i := 0; i < len(xx); i++ {
				xxx := strings.Split(xx[i], "_")
				var newData data

				newData.ano, _ = strconv.Atoi(xxx[0])
				newData.mes, _ = strconv.Atoi(xxx[1])
				newData.dia, _ = strconv.Atoi(xxx[2])
				newData.hora, _ = strconv.Atoi(xxx[3])
				newData.minuto, _ = strconv.Atoi(xxx[4])
				id.visitasConf = append(id.visitasConf, newData)
			}
		}

		x = fmt.Sprintf("%v", doc.Data()["Posts"])
		x = strings.Replace(x, "[", "", -1)
		x = strings.Replace(x, "]", "", -1)
		id.posts = strings.Split(x, " ")

		x = fmt.Sprintf("%v", doc.Data()["Kits"])
		reg, err := regexp.Compile("[^0-9 ]+")
		xNN := reg.ReplaceAllString(x, "")
		xNN = removeDups(xNN)
		lNumKit := strings.Split(xNN, " ")
		//x = strings.Replace(x, "", "", -1)
		x = strings.Replace(x, "0", "", -1)
		x = strings.Replace(x, "1", "", -1)
		x = strings.Replace(x, "2", "", -1)
		x = strings.Replace(x, "3", "", -1)
		x = strings.Replace(x, "4", "", -1)
		x = strings.Replace(x, "5", "", -1)
		x = strings.Replace(x, "6", "", -1)
		x = strings.Replace(x, "7", "", -1)
		x = strings.Replace(x, "8", "", -1)
		x = strings.Replace(x, "9", "", -1)
		x = strings.Replace(x, "]", "", -1)
		x = strings.Replace(x, "[", "", -1)
		//xNN := strings.Replace(x, "abcdefghijklmnopqrstuvwxyz ", "", -1)

		lNumKit = RemoveIndex(lNumKit, len(lNumKit)-1)

		lenght := 0
		if len(lNumKit) > 0 {
			lenght, _ = strconv.Atoi(lNumKit[len(lNumKit)-1])
		}
		fmt.Print(lenght)
		k := strings.Split(x, ":")
		k = RemoveIndex(k, 0)

		for i := 0; i < len(lNumKit); i++ {
			ll := strings.Split(k[i], " ")
			var lf []bool

			for j := 0; j < len(ll); j++ {
				if ll[j] == "false" {
					lf = append(lf, false)
				} else if ll[j] == "true" {
					lf = append(lf, true)
				}
			}
			if len(lf) == 0 {
				lf = append(lf, false)
			}
			id.kits = append(id.kits, lf)
		}
		fmt.Print("\n")

		Pessoas = append(Pessoas, id)
		printPerson(id)
	}

}

//ShowMenu mostra o menu
func ShowMenu(selection *int) {
	fmt.Printf(" ---- Menu Options ---- \n\n")
	fmt.Printf(" 1 - Logins \n")
	fmt.Printf(" 2 - Info \n")
	fmt.Printf(" 3 - Avisos \n")
	fmt.Printf(" 4 - Posts \n")
	fmt.Printf(" 5 - Kits \n")
	fmt.Printf(" 6 - Calendar \n")
	fmt.Printf(" 0 - Exit \n")
	fmt.Scanf("%d", selection)
	for *selection < 0 || *selection > 6 {
		fmt.Scanf("%d", selection)
		if *selection < 0 || *selection > 6 {
			fmt.Printf(" %d não esta no limite", *selection)
		}
	}
}
