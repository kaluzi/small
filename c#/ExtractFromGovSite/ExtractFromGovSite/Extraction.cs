using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ExtractFromGovSite
{
    public partial class Extraction : Form
    {
        public Extraction()
        {
            InitializeComponent();
        }

        private void extractBtn_Click(object sender, EventArgs e)
        {
            progressBox.Text = "Retrieving Data and Writing to file...";
            //for (int id = 2; id <= 7356; id++)
                getData(225);
            progressBox.Text = "Finished.";
        }

        private void getData(int id)
        {
            List<string> names = new List<string>();
            List<string> titles = new List<string>();
            List<string> phones = new List<string>();
            WebClient web = new WebClient();
            String html = web.DownloadString("http://www.infogo.gov.on.ca/infogo/office.do?actionType=telephonedirectory&infoType=telephone&unitId=" + id + "&locale=en");
            MatchCollection m1 = Regex.Matches(html, "<A class=\"employee\" href=javascript:browseEmployee\\('.+?'\\)>\\s*(.+?)\\s*</A>", RegexOptions.Singleline);
            MatchCollection m2 = Regex.Matches(html, "<A class=\"employee\".+?</A>\\]\\s*\\[\\s*(.+?)\\s*\\]", RegexOptions.Singleline);
            MatchCollection m3 = Regex.Matches(html, "<A class=\"employee\".+?</A>\\]\\s*\\[.+?\\].+?\\[(.+?)\\]", RegexOptions.Singleline);
            string dept = Regex.Match(html, "<a  href=.+?actionType=telephonedirectory&infoType=telephone&unitId=.+?>\\s*(.+?)\\s*</a>").Groups[1].Value;
            string city = Regex.Match(html, "<font class='bodycontext'>(.+?)&nbsp;").Groups[1].Value;
            using (StreamWriter sw = new StreamWriter("C:\\Users\\klu\\Desktop\\depts.txt", true))
            {
                foreach (Match m in m1)
                {
                    sw.WriteLine(dept);
                }
            }
            using (StreamWriter sw = new StreamWriter("C:\\Users\\klu\\Desktop\\cities.txt", true))
            {
                foreach (Match m in m1)
                {
                    sw.WriteLine(city);
                }
            }

            using (StreamWriter sw = new StreamWriter("C:\\Users\\klu\\Desktop\\names.txt", true))
            {
                foreach (Match m in m1)
                {
                    string name = m.Groups[1].Value;
                    names.Add(name);
                    sw.WriteLine(name);
                }
            }
            using (StreamWriter sw = new StreamWriter("C:\\Users\\klu\\Desktop\\titles.txt", true))
            {
                foreach (Match m in m2)
                {
                    string title = m.Groups[1].Value;
                    titles.Add(title);
                    sw.WriteLine(title);
                }
            }
            using (StreamWriter sw = new StreamWriter("C:\\Users\\klu\\Desktop\\phones.txt", true))
            {
                foreach (Match m in m3)
                {
                    string phone = m.Groups[1].Value;
                    phones.Add(phone);
                    sw.WriteLine(phone);
                }
            }

        }
    }
}
