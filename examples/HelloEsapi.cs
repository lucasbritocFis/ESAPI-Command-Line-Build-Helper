using System;
using System.Linq;
using System.Reflection;
using System.Windows.Forms;
using VMS.TPS.Common.Model.API;
using VMS.TPS.Common.Model.Types;

[assembly: AssemblyVersion("1.0.0.0")]
[assembly: ESAPIScript(IsWriteable = false)]

namespace VMS.TPS
{
    // Minimal read-only example.
    // Written against C# 5: no string interpolation, so it compiles with the
    // csc.exe shipped with the .NET Framework.
    public class Script
    {
        public void Execute(ScriptContext context)
        {
            if (context.Patient == null)
            {
                MessageBox.Show("No patient is open.", "Hello ESAPI");
                return;
            }

            StructureSet ss = context.StructureSet;
            if (ss == null)
            {
                MessageBox.Show("No active structure set.", "Hello ESAPI");
                return;
            }

            var structures = ss.Structures
                .Where(s => !s.IsEmpty)
                .Select(s => s.Id)
                .OrderBy(id => id)
                .ToList();

            // Patient ID only - no names, so screenshots stay safe to share.
            string msg =
                "Patient ID: " + context.Patient.Id + Environment.NewLine +
                "Structure set: " + ss.Id + Environment.NewLine +
                "Non-empty structures (" + structures.Count + "):" + Environment.NewLine +
                string.Join(", ", structures);

            MessageBox.Show(msg, "ESAPI build succeeded");
        }
    }
}
