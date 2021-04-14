//
//  VaccineModel.swift
//  InfantoryApp
//
//  Created by Gilbert Nicholas on 08/04/21.
//

import Foundation

struct Vaccine {
    private(set) var id: Int64 = -1
    private(set) var moonId: Int = -1
    private(set) var name: String = ""
    private(set) var icon: String = ""
    private(set) var description: String = ""
    var isTrue: Bool = false
    
    
    static func generateVaccine() -> [Vaccine] {
        return [
            Vaccine(id : 0, moonId: 0, name: "HepB-1", icon: "iconHepatitisB", description: getHBdesc(), isTrue: false),
            Vaccine(id : 1, moonId: 1, name: "BCG", icon: "iconBCG", description: getBCGdesc(), isTrue: false),
            Vaccine(id : 2, moonId: 1, name: "Polio 1", icon: "iconPolio", description: getPolioDesc(), isTrue: false),
            Vaccine(id : 3, moonId: 2, name: "HepB-2", icon: "iconHepatitisB", description: getHBdesc(), isTrue: false),
            Vaccine(id : 4, moonId: 2, name: "Polio 2", icon: "iconPolio", description: getHBdesc(), isTrue: false),
            Vaccine(id : 5, moonId: 2, name: "DTaP-1", icon: "iconDTP", description: getDPTdesc(), isTrue: false),
            Vaccine(id : 6, moonId: 2, name: "Hib", icon: "iconHib", description:getHibDesc(), isTrue: false),
            Vaccine(id : 7, moonId: 2, name: "PCV", icon: "iconPCV", description: getPCVdesc(), isTrue: false),
            Vaccine(id : 8, moonId: 2, name: "Rotavirus Monovalent", icon: "iconRotaMono", description: getRotaMonoDesc(), isTrue: false),
            Vaccine(id : 9, moonId: 3, name: "HepB-3", icon: "iconHepatitisB", description: getHBdesc(), isTrue: false),
            Vaccine(id : 10, moonId: 3, name: "Polio 3", icon: "iconPolio", description: getHBdesc(), isTrue: false),
            Vaccine(id : 11, moonId: 3, name: "DTaP-2", icon: "iconDTP", description: getDPTdesc(), isTrue: false),
            Vaccine(id : 12, moonId: 3, name: "Hib", icon: "iconHib", description:getHibDesc(), isTrue: false),
            Vaccine(id : 13, moonId: 4, name: "HepB-4", icon: "iconHepatitisB", description: getHBdesc(), isTrue: false),
            Vaccine(id : 14, moonId: 4, name: "Polio 3", icon: "iconPolio", description: getHBdesc(), isTrue: false),
            Vaccine(id : 15, moonId: 4, name: "DTaP-3", icon: "iconDTP", description: getDPTdesc(), isTrue: false),
            Vaccine(id : 16, moonId: 4, name: "PCV 2", icon: "iconPCV", description: getPCVdesc(), isTrue: false),
            Vaccine(id : 17, moonId: 4, name: "Rotavirus Monovalent 2", icon: "iconRotaMono", description: getRotaMonoDesc(), isTrue: false),
            Vaccine(id : 18, moonId: 6, name: "PCV 3", icon: "iconPCV", description: getPCVdesc(), isTrue: false),
            Vaccine(id : 19, moonId: 6, name: "Rotavirus Pentavalent 1", icon: "iconRotaMono", description: getRotaPentaDesc(), isTrue: false),
            Vaccine(id : 20, moonId: 6, name: "Influenza", icon: "iconFlu", description: getFluDesc(), isTrue: false),
            Vaccine(id : 21, moonId: 9, name: "MR", icon: "iconMR", description: getMRdesc(), isTrue: false),
            Vaccine(id : 22, moonId: 9, name: "JE", icon: "iconJE", description: getJEdesc(), isTrue: false),
            Vaccine(id : 23, moonId: 11, name: "PCV 4", icon: "iconPCV", description: getDPTdesc(), isTrue: false),
            Vaccine(id : 24, moonId: 12, name: "JE", icon: "iconJE", description: getJEdesc(), isTrue: false),
        ]
    }
    
    static func sortVaccine(_ moonId: Int) -> [Vaccine] {
        let vaccines = generateVaccine()
        
        var sendVaccines: [Vaccine] = []
        
        for selectedVaccines in vaccines {
            
            if selectedVaccines.moonId == moonId {
                sendVaccines.append(selectedVaccines)
            }
        }
        return sendVaccines
    }
    
    static func getHBdesc() -> String{
        return "Hepatitis B is a contagious liver disease caused by the hepatitis B virus. When a person is first infected with the virus, he or she can develop an “acute” (short-term) infection. Acute hepatitis B refers to the first 6 months after someone is infected with the hepatitis B virus. This infection can range from a very mild illness with few or no symptoms to a serious condition requiring hospitalization. Some people are able to fight the infection and clear the virus. \nFor others, the infection remains and is chronic or lifelong. Chronic hepatitis B refers to the infection when it remains active instead of getting better after 6 months. Over time, the infection can cause serious health problems, and even liver cancer. \nMothers can unknowingly pass hepatitis B to their babies at birth. The hepatitis B shot is very safe, and is effective at preventing hepatitis B. This shot works best when your baby gets it within the first 12 hours of his life. \n\nThe most common side effects of the hepatitis B vaccine are mild and include: \n- Low fever (less than 101 degrees) or, \n- Sore arm from the shot."
    }
    
    static func getBCGdesc() -> String{
        return "The BCG vaccine protects against tuberculosis, which is also known as TB. TB is a serious infection that affects the lungs and sometimes other parts of the body, such as the bones, joints and kidneys. It can also cause meningitis. \nThe BCG vaccine is made from a weakened strain of TB bacteria. Because the bacteria in the vaccine is weak, it triggers the immune system to protect against the disease. \n\nThe most common side effects of the BCG vaccine are mild and include: \n- Sore arm from the shot."
    }
    
    static func getPolioDesc() -> String{
        return "Polio, or poliomyelitis, is a disabling and life-threatening disease caused by the poliovirus. The virus can infect a person’s spinal cord, causing paralysis (can’t move parts of the body). Paralysis caused by poliovirus occurs when the virus replicates in and attacks the nervous system. The paralysis can be lifelong, and it can be deadly. It most often sickens children younger than 5 years old. \n\nThe most common side effects of the Polio vaccine are mild and include: \n- Redness, swelling, or pain where the shot was given"
    }
    
    static func getDPTdesc() -> String{
        return "Vaccine diphtheria, tetanus, and whooping cough (pertussis) (DTaP), combination vaccine that can prevent deadly disease in these babies. Diphtheria is a disease that can make it difficult for babies to breathe, become paralyzed, and have heart failure. Tetanus is a disease that can cause muscle stiffness. Meanwhile, pertussis is a whooping cough which can make a baby cough so badly that they can't breathe and often result in death. \n\nMost children don’t have any side effects from DTaP or Tdap. \n\nThe side effects that do occur are usually mild, and may include: \n- Redness, swelling, or pain where the shot was given \n- Fever \n- Vomiting \n\nMore serious side effects are very rare but with DTaP can include:\n- A fever over 105 degrees \n- Nonstop crying for 3 hours or more \n- Seizures (jerking, twitching of the muscles, or staring)"
    }
    
    static func getHibDesc() -> String{
        return "Hib disease is a serious illness caused by the bacteria Haemophilus influenzae type b (Hib). Babies and children younger than 5 years old are most at risk for Hib disease. It can cause lifelong disability and be deadly. The most common type of Hib disease is meningitis. This is an infection of the tissue covering the brain and spinal cord. Hib disease is very serious. Most children with Hib disease need care in the hospital. Even with treatment, as many as 1 out of 20 children with Hib meningitis dies. As many as 1 out of 5 children who survive Hib meningitis will have brain damage or become deaf. \n\nMost children don’t have any side effects from the shot. The side effects that do occur are usually mild, and may include: \n- Redness, swelling, warmth, or pain where the shot was given. \n- Fever"
    }
    
    static func getMRdesc() -> String{
        return "MR Vaccine prevents measles and rubella. Measles is a contagious disease and causes a high fever and rash and can lead to blindness, encephalitis and death. While rubella is a viral infection that can have a mild impact on children, but can be fatal for pregnant women. \n\nMost children don’t have any side effects from the shot. The side effects that do occur are usually mild and may include: \n- Soreness, redness, or swelling where the shot was given. \n- Fever \n- Mild rash \n- Temporary pain and stiffness in the joints \n\nMore serious side effects are rare. These may include high fever that could cause a seizure."
    }
    
    static func getPCVdesc() -> String{
        return "Pneumococcal Conjugate Vaccine (PCV) prevents Pneumococcal disease can cause infections of the ears, lungs, blood, and brain. Pneumococcal disease is an illness caused by bacteria called pneumococcus. It is often mild, but can cause serious symptoms, lifelong disability, or death. Children younger than 2 years old are among those most at risk for the disease. \n\nPneumococcal disease ranges from mild to very dangerous. About 2,000 cases of serious disease (bacteremia, pneumonia with bacteremia, and meningitis) occur each year in children under 5 years old in the United States. These illnesses can lead to disabilities like deafness, brain damage, or loss of arms or legs. About 1 out of 15 children who get pneumococcal meningitis dies. \n\nMost children don’t have any side effects from the shot. The side effects that do occur are usually mild, and may include: \n- Fussiness \n- Feeling tired \n- Loss of appetite (not want to eat) \n- Redness, swelling, or soreness where the shot was given \n- Fever or chills \n- Headache"
    }
    
    static func getRotaMonoDesc() -> String{
        return "Rotavirus Monovalen (RV1) Vaccine (Rotarix®) protects against Rotavirus. Rotavirus causes severe diarrhea and vomiting. It affects mostly babies and young children. Diarrhea and vomiting can lead to serious dehydration (loss of body fluid). If dehydration is not treated, it can be deadly. Diarrhea and vomiting can last for three to eight days. Children may stop eating and drinking while they are sick. \n\nRotavirus can survive on objects for several days. It is very difficult to stop its spread just by hand washing or disinfecting surfaces. The best way to protect young children from rotavirus is to get them vaccinated. \n\nThe effects are rare, usually mild, and may include fussiness, diarrhea, and vomiting."
    }
    
    static func getRotaPentaDesc() -> String{
        return "otavirus Pentavalen (RV5) Vaccine (RotaTeq®) protects against Rotavirus. Rotavirus causes severe diarrhea and vomiting. It affects mostly babies and young children. Diarrhea and vomiting can lead to serious dehydration (loss of body fluid). If dehydration is not treated, it can be deadly. Diarrhea and vomiting can last for three to eight days. Children may stop eating and drinking while they are sick. \n\nRotavirus can survive on objects for several days. It is very difficult to stop its spread just by hand washing or disinfecting surfaces. The best way to protect young children from rotavirus is to get them vaccinated. \n\nThe effects are rare, usually mild, and may include fussiness, diarrhea, and vomiting."
    }
    
    static func getFluDesc() -> String{
        return "Flu—short for influenza—is an illness caused by influenza viruses. Flu viruses infect the nose, upper airways, throat, and lungs. Flu spreads easily and can cause serious illness, especially for young children, older people, pregnant women, and people with certain chronic conditions like asthma and diabetes. \nFlu viruses are constantly changing, so new vaccines are made each year to protect against the flu viruses that are likely to cause the most illness. Also, protection provided by flu vaccination wears off over time. Your child’s flu vaccine will protect against flu all season, but they will need a vaccine again next flu season for best protection against flu. \nDoctors recommend that your child get a flu vaccine every year in the fall, starting when he or she is 6 months old. Some children 6 months through 8 years of age may need 2 doses for best protection. Your child’s doctor will know which vaccines are right for your child. \n- Flu shots can be given to your child 6 months and older. \n- The nasal spray vaccine can be given to people 2 through 49 years of age. However, certain people with underlying medical conditions should not get the nasal spray vaccine."
    }
    
    static func getJEdesc() -> String{
        return "Japanese encephalitis (JE) is an infectious disease of the Japanese encephalitis virus that is transmitted by mosquitoes. This disease is the most common cause of inflammatory brain disease in most of Asia and parts of the Western Pacific, including Indonesia. \n\nJE can cause death. There are 67,900 cases of JE each year, with a mortality rate of 20-30% and resulting in 30-50% residual neurological symptoms. This mortality rate is higher in children, especially children aged less than 10 years. Even if they survive, usually sufferers often experience sequelae (sequelae), including motor system disorders (fine motor skills, paralysis, abnormal movements); behavioral disorders (aggressive, uncontrolled emotions, attention disorders, depression); or intellectual impairment (retardation); or other neurological dysfunction (memory impairment, epilepsy, blindness. \n\nUntil now, no cure has been found to treat Japanese encephalitis infection. Although this disease can cause disability and death, it can be prevented by vaccines."
    }
}
