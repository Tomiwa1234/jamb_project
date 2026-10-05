// Practice questions written in JAMB style. Add more subjects, years or questions here.
import '../models/question.dart';

final Map<String, Map<String, List<Question>>> questionBank = {
  'Use of English': {
    '2021': [
      Question(
        'Choose the word nearest in meaning to \'ephemeral\'.',
        ['Lasting', 'Short-lived', 'Beautiful', 'Heavy'],
        1,
        'Ephemeral means lasting a very short time.',
      ),
      Question(
        'Neither the teacher nor the students ___ present at the meeting.',
        ['is', 'was', 'were', 'has been'],
        2,
        'With neither/nor the verb agrees with the nearer subject (students).',
      ),
      Question(
        'Choose the word opposite in meaning to \'benevolent\'.',
        ['Kind', 'Generous', 'Malevolent', 'Gentle'],
        2,
        'Malevolent means wishing harm.',
      ),
      Question(
        '\'The thief was caught red-handed.\' This means he was caught ___.',
        ['Bleeding', 'In the act', 'Running away', 'Angry'],
        1,
        'Red-handed = while committing the act.',
      ),
    ],
    '2022': [
      Question(
        'Choose the correct option: She is senior ___ me.',
        ['than', 'to', 'from', 'over'],
        1,
        '\'Senior\' takes \'to\', not \'than\'.',
      ),
      Question(
        'Pick the word nearest in meaning to \'candid\'.',
        ['Frank', 'Secretive', 'Sweet', 'Rude'],
        0,
        'Candid means open and honest.',
      ),
      Question(
        'The plural of \'crisis\' is',
        ['crisises', 'crises', 'crisis', 'crisees'],
        1,
        'Crisis → crises.',
      ),
      Question(
        'Choose the word that best completes: He ran ___ the road.',
        ['cross', 'across', 'acros', 'crossing'],
        1,
        '\'Across\' is the preposition.',
      ),
    ],
    '2023': [
      Question(
        'Choose the word opposite in meaning to \'scarce\'.',
        ['Rare', 'Plentiful', 'Costly', 'Little'],
        1,
        'Scarce means in short supply; plentiful is the opposite.',
      ),
      Question(
        'Each of the boys ___ a book.',
        ['have', 'has', 'are', 'were having'],
        1,
        '\'Each\' is singular.',
      ),
      Question(
        '\'To kick the bucket\' means to',
        ['Waste time', 'Die', 'Fail a test', 'Be angry'],
        1,
        'An idiom meaning to die.',
      ),
      Question(
        'Choose the correctly spelt word.',
        ['Accomodation', 'Acommodation', 'Accommodation', 'Acomodation'],
        2,
        'Accommodation has double c and double m.',
      ),
    ],
  },
  'Mathematics': {
    '2021': [
      Question(
        'Solve for x: 2x + 5 = 17',
        ['4', '5', '6', '7'],
        2,
        '2x = 12 so x = 6.',
      ),
      Question(
        'Simplify 3² × 3³',
        ['81', '243', '729', '27'],
        1,
        '3^(2+3) = 243.',
      ),
      Question(
        'Find the area of a circle of radius 7 cm. (π = 22/7)',
        ['44 cm²', '154 cm²', '49 cm²', '308 cm²'],
        1,
        'πr² = 22/7 × 49 = 154.',
      ),
      Question('Evaluate log₁₀ 1000', ['1', '2', '3', '10'], 2, '10³ = 1000.'),
    ],
    '2022': [
      Question(
        'If y = 3x − 2 and x = 4, find y.',
        ['10', '12', '14', '8'],
        0,
        '3(4) − 2 = 10.',
      ),
      Question(
        'What is 25% of 240?',
        ['50', '60', '70', '80'],
        1,
        '0.25 × 240 = 60.',
      ),
      Question(
        'Factorise x² − 9.',
        ['(x−3)(x−3)', '(x+3)(x−3)', '(x+9)(x−1)', 'x(x−9)'],
        1,
        'Difference of two squares.',
      ),
      Question(
        'The sum of angles in a triangle is',
        ['90°', '180°', '270°', '360°'],
        1,
        'Always 180°.',
      ),
    ],
    '2023': [
      Question(
        'Find the value of √144 ÷ 3.',
        ['3', '4', '6', '12'],
        1,
        '12 ÷ 3 = 4.',
      ),
      Question(
        'Express 0.375 as a fraction in lowest terms.',
        ['3/8', '3/5', '1/3', '5/8'],
        0,
        '375/1000 = 3/8.',
      ),
      Question(
        'Solve x² − 5x + 6 = 0.',
        ['x = 1, 6', 'x = 2, 3', 'x = −2, −3', 'x = 5, 1'],
        1,
        '(x−2)(x−3)=0.',
      ),
      Question(
        'The mean of 2, 4, 6, 8 is',
        ['4', '5', '6', '20'],
        1,
        '20 ÷ 4 = 5.',
      ),
    ],
  },
  'Physics': {
    '2021': [
      Question(
        'The SI unit of force is the',
        ['Joule', 'Watt', 'Newton', 'Pascal'],
        2,
        'Force is measured in newtons.',
      ),
      Question(
        'A car covers 20 m in 4 s. Its average speed is',
        ['4 m/s', '5 m/s', '16 m/s', '80 m/s'],
        1,
        '20 ÷ 4 = 5 m/s.',
      ),
      Question(
        'Which of these is a vector quantity?',
        ['Speed', 'Mass', 'Velocity', 'Time'],
        2,
        'Velocity has magnitude and direction.',
      ),
      Question(
        'Find the current if V = 12 V and R = 4 Ω.',
        ['2 A', '3 A', '4 A', '8 A'],
        1,
        'I = V/R = 3 A.',
      ),
    ],
    '2022': [
      Question(
        'The unit of power is the',
        ['Joule', 'Watt', 'Newton', 'Hertz'],
        1,
        'Power is measured in watts.',
      ),
      Question(
        'Which of the following is a form of energy due to position?',
        ['Kinetic', 'Potential', 'Sound', 'Heat'],
        1,
        'Potential energy depends on position.',
      ),
      Question(
        'Light travels fastest in',
        ['Water', 'Glass', 'Vacuum', 'Air'],
        2,
        'Light is fastest in a vacuum.',
      ),
      Question(
        'The acceleration due to gravity near Earth is about',
        ['9.8 m/s²', '98 m/s²', '0.98 m/s²', '1 m/s²'],
        0,
        'g ≈ 9.8 m/s².',
      ),
    ],
    '2023': [
      Question(
        'Work done = force × ',
        ['time', 'distance moved', 'mass', 'speed'],
        1,
        'W = F × d.',
      ),
      Question(
        'The bending of light as it passes from one medium to another is',
        ['Reflection', 'Refraction', 'Diffraction', 'Dispersion'],
        1,
        'That is refraction.',
      ),
      Question(
        'A body of mass 5 kg accelerates at 2 m/s². The force is',
        ['2.5 N', '7 N', '10 N', '3 N'],
        2,
        'F = ma = 10 N.',
      ),
      Question(
        'The device used to measure atmospheric pressure is a',
        ['Thermometer', 'Barometer', 'Ammeter', 'Hydrometer'],
        1,
        'A barometer.',
      ),
    ],
  },
  'Chemistry': {
    '2021': [
      Question(
        'The atomic number of an element is the number of its',
        ['Neutrons', 'Protons', 'Nucleons', 'Isotopes'],
        1,
        'Atomic number = number of protons.',
      ),
      Question(
        'Which of these is a noble gas?',
        ['Oxygen', 'Nitrogen', 'Argon', 'Chlorine'],
        2,
        'Argon is in Group 18.',
      ),
      Question(
        'The pH of a neutral solution is',
        ['0', '7', '14', '1'],
        1,
        'Neutral pH is 7.',
      ),
      Question(
        'The chemical formula of table salt is',
        ['KCl', 'NaCl', 'CaCl₂', 'NaOH'],
        1,
        'Sodium chloride, NaCl.',
      ),
    ],
    '2022': [
      Question(
        'Which gas is evolved when zinc reacts with dilute HCl?',
        ['Oxygen', 'Hydrogen', 'Chlorine', 'CO₂'],
        1,
        'Zn + 2HCl → ZnCl₂ + H₂.',
      ),
      Question(
        'Rusting requires oxygen and',
        ['Nitrogen', 'Water', 'Helium', 'Neon'],
        1,
        'Iron rusts with air and moisture.',
      ),
      Question(
        'The process of separating a liquid from a solution by boiling and condensing is',
        ['Filtration', 'Distillation', 'Sublimation', 'Decantation'],
        1,
        'Distillation.',
      ),
      Question(
        'Which is an alkane?',
        ['C₂H₄', 'C₂H₆', 'C₂H₂', 'C₆H₆'],
        1,
        'Alkanes: CₙH₂ₙ₊₂, so C₂H₆.',
      ),
    ],
    '2023': [
      Question(
        'The number of moles in 36 g of water (H=1, O=16) is',
        ['1', '2', '3', '4'],
        1,
        '36 ÷ 18 = 2.',
      ),
      Question(
        'An acid turns blue litmus',
        ['Green', 'Red', 'Colourless', 'Yellow'],
        1,
        'Acids turn blue litmus red.',
      ),
      Question(
        'Which element has the symbol Fe?',
        ['Fluorine', 'Iron', 'Francium', 'Lead'],
        1,
        'Fe is iron.',
      ),
      Question(
        'The type of bond in NaCl is',
        ['Covalent', 'Ionic', 'Metallic', 'Hydrogen'],
        1,
        'Metal + non-metal gives ionic bonding.',
      ),
    ],
  },
  'Biology': {
    '2021': [
      Question(
        'The powerhouse of the cell is the',
        ['Nucleus', 'Mitochondrion', 'Ribosome', 'Vacuole'],
        1,
        'Mitochondria release energy by respiration.',
      ),
      Question(
        'Photosynthesis takes place mainly in the',
        ['Root', 'Leaf', 'Stem', 'Flower'],
        1,
        'Leaves contain most chloroplasts.',
      ),
      Question(
        'Which blood cells fight infection?',
        ['Red cells', 'White cells', 'Platelets', 'Plasma'],
        1,
        'White blood cells defend the body.',
      ),
      Question(
        'The basic unit of heredity is the',
        ['Cell', 'Gene', 'Tissue', 'Organ'],
        1,
        'Genes carry hereditary information.',
      ),
    ],
    '2022': [
      Question(
        'The vector of malaria is the',
        ['Housefly', 'Female Anopheles mosquito', 'Tsetse fly', 'Tick'],
        1,
        'Female Anopheles transmits Plasmodium.',
      ),
      Question(
        'Which organ produces insulin?',
        ['Liver', 'Pancreas', 'Kidney', 'Stomach'],
        1,
        'Pancreas (islets of Langerhans).',
      ),
      Question(
        'Loss of water vapour from leaves is',
        ['Respiration', 'Transpiration', 'Excretion', 'Osmosis'],
        1,
        'Transpiration.',
      ),
      Question(
        'The green pigment in plants is',
        ['Xanthophyll', 'Chlorophyll', 'Carotene', 'Melanin'],
        1,
        'Chlorophyll.',
      ),
    ],
    '2023': [
      Question(
        'The part of the brain that controls balance is the',
        ['Cerebrum', 'Cerebellum', 'Medulla', 'Hypothalamus'],
        1,
        'Cerebellum coordinates balance.',
      ),
      Question(
        'An organism that feeds on dead organic matter is a',
        ['Parasite', 'Saprophyte', 'Predator', 'Producer'],
        1,
        'Saprophytes feed on dead matter.',
      ),
      Question(
        'Which vitamin prevents scurvy?',
        ['A', 'B', 'C', 'D'],
        2,
        'Vitamin C deficiency causes scurvy.',
      ),
      Question(
        'The site of gaseous exchange in the lungs is the',
        ['Bronchus', 'Alveolus', 'Trachea', 'Diaphragm'],
        1,
        'Alveoli.',
      ),
    ],
  },
};
